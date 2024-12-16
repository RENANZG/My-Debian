# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       qubes
:platform:      all

================
Module Utilities
================
'''

from __future__ import absolute_import

# Import python libs
import pipes
import types
import argparse  # pylint: disable=E0598
import logging

# Salt libs
from salt.exceptions import (CommandExecutionError, SaltInvocationError)

# Salt + Qubes libs
# pylint: disable=E0401
from qubes_utils import (
    Status, coerce_to_string, coerce_to_list
)

# Enable logging
import grp

log = logging.getLogger(__name__)

# Used to identify values that have not been passed to functions which allows
# the function modules not to have to know anything about the default types
# expected
try:
    if MARKER:
        pass
except NameError:
    MARKER = object()

try:
    __context__['module_utils_loaded'] = True
except NameError:
    __context__ = {}


class ArgparseFunctionWrapper(object):
    '''
    Wraps functions to appear as string.

    Argparse only allows file, str or int types so to be able to use argparse
    to parse other types, they can be wrapped and will appear as 'None'.

    Function is still callable.
    '''

    def __init__(self, func):
        self.func = func

    def __len__(self):
        return 0

    def __call__(self, *varargs, **kwargs):
        self.func(*varargs, **kwargs)


class ModuleBase(object):
    '''
    ModuleBase is a base class which contains base functionality and utility
    to implement the qvm-* commands.
    '''

    def _set_debug_mode(self, args):
        __context__.setdefault('debug', [])

        if args.debug_mode is not None:
            if args.debug_mode:
                if 'debug' not in args.status_mode:
                    args.status_mode.append('debug')

                if self.__virtualname__ not in __context__['debug']:
                    __context__['debug'].append(self.__virtualname__)

            else:
                if 'debug' in args.status_mode:
                    args.status_mode.remove('debug')

                if self.__virtualname__ in __context__['debug']:
                    __context__['debug'].remove(self.__virtualname__)

        elif self.__virtualname__ in __context__[
            'debug'
        ] or '__all__' in __context__['debug']:
            if 'debug' not in args.status_mode:
                args.status_mode.append('debug')

        self._debug_mode = __context__['debug']

    def __init__(self, __virtualname, **kwargs):
        self._data = []
        self.args = None
        self.__virtualname__ = __virtualname

        # Defaults
        self.defaults = argparse.Namespace()

        # Initial status_mode options
        self.defaults.run_post_hook = kwargs.pop('run-post-hook', None)

        # Type of status mode to use (default: last)
        self.defaults.status_mode = coerce_to_list(
            kwargs.pop(
                'status-mode', 'last'
            )
        )

        # pylint: disable=E0598
        if not {
            'last', 'all'
        }.intersection(self.defaults.status_mode):
            self.defaults.status_mode.append('last')

        # Determine if called via CLI
        self.defaults.cli_mode = True if '__pub_fun' in kwargs else False

        # Set debug mode
        self.defaults.debug_mode = kwargs.pop('debug-mode', None)
        self._set_debug_mode(self.defaults)

        # Salt module parser
        self.argparser = ArgumentParser(prog=__virtualname)
        self.argparser.add_argument_group('salt')
        self.parser = self.argparser.get_argument_group('salt')

        # User to run commands as
        qubes_group = grp.getgrnam('qubes')

        if not len(qubes_group.gr_mem):
            raise SaltInvocationError("Group 'qubes' has no members")

        self.run_as_user = qubes_group.gr_mem[0]

    def parse_args(self, *varargs, **kwargs):
        self.args = self.argparser.parse_salt_args(*varargs, **kwargs)
        return self.args

    def save_status(
        self,
        status=None,
        retcode=None,
        result=None,
        data=None,
        prefix=None,
        message='',
        error_message=''
    ):
        '''
        Merges data from individual status into master data dictionary
        which will be returned and includes all changes and comments as well
        as the overall status status.

        :param status:
        :param retcode:
        :param result:
        :param data:
        :param prefix:
        :param message:
        :param error_message:
        '''
        # Create a default status if one does not exist
        if status is None:
            status = Status()

        if not status.name:
            status.name = self.__virtualname__

        # pylint: disable=W0212
        status._format(
            retcode=retcode,
            result=result,
            data=data,
            prefix=prefix,
            message=message,
            error_message=error_message
        )
        self._data.append(status)

        return status

    def run(
        self,
        cmd,
        test_ignore=False,
        post_hook=None,
        data=None,
        **options
    ):
        '''
        Executes cmd using salt.utils run_all function.

        Fake status are returned instead of executing the command if test
        mode is enabled.

        :param cmd:
        :param test_ignore:
        :param post_hook:
        :param data:
        '''
        if __opts__['test'] and not test_ignore:
            status = Status(retcode=0, prefix='[TEST] ')

        else:
            if isinstance(cmd, list):
                cmd = ' '.join(pipes.quote(c) for c in cmd)

            status = Status(
                **__salt__['cmd.run_all'](
                    cmd,
                    runas=self.run_as_user,
                    output_loglevel='quiet',
                    **options
                )
            )
            delattr(status, 'pid')

        self._run_post_hook(post_hook, cmd, status, data)

        cmd_options = str(options) if options else ''
        cmd_string = '{0} {1}'.format(cmd, cmd_options)

        return self.save_status(status, message=cmd_string)

    def _run_post_hook(self, post_hook, cmd, status, data):
        '''
        Execute and post hooks if they exist.
        '''
        if post_hook:
            post_hook(cmd, status, data)

        if self.defaults.run_post_hook:
            self.defaults.run_post_hook(cmd, status, data)

    def status(self):
        '''
        Returns finalized merged 'data' status.
        '''
        status = Status()
        status_mode = 'last' if 'last' in self.defaults.status_mode else 'all'
        debug_mode = True if 'debug' in self.defaults.status_mode else False

        # pylint: disable=W0212
        return status._finalize(
            data=self._data,
            status_mode=status_mode,
            cli_mode=self.defaults.cli_mode,
            debug_mode=debug_mode,
            test_mode=__opts__['test']
        )


class ArgumentParser(argparse.ArgumentParser):
    '''
    Custom ArgumentParser.
    '''

    def __init__(self, **kwargs):
        super(ArgumentParser, self).__init__(**kwargs)

        self.options = dict(
            flags=['flags'],
            hide=None,
            pop=False,
            namespace=None
        )

    def error(self, message):
        '''
        error(message: string)

        Raises a Salt CommandExecutionError.

        If you override this in a subclass, it should not return -- it
        should either exit or raise an exception.

        :param message:
        '''
        raise CommandExecutionError(
            '{0}: error: {1}\n'.format(
                self.prog, message
            )
        )

    def get_argument_group(self, group):
        for action_group in self._action_groups:
            if action_group.title == group:
                return action_group
        return None

    def parse_args(self, args=None, namespace=None):
        if namespace is None and self.options.get(
            'namespace', None
        ) is not None:
            namespace = self.options['namespace']

        return super(ArgumentParser, self).parse_args(
            args=args,
            namespace=namespace
        )

    def parse_known_args(self, args=None, namespace=None):
        if namespace is None and self.options.get(
            'namespace', None
        ) is not None:
            namespace = self.options['namespace']

        return super(ArgumentParser, self).parse_known_args(
            args=args,
            namespace=namespace
        )

    def parse_salt_args(self, *varargs, **kwargs):
        arg_info = self.create_argv_list('salt', *varargs, **kwargs)
        args = self.parse_args(args=arg_info['__argv'])
        args._arg_info = arg_info  # pylint: disable=W0212
        # pylint: disable=W0212
        args._argv = arg_info['__argv_hidden'] or arg_info[
            '__argv'
        ]
        return args

    def get_argument_group_keys(self, group, adict=None, first_only=True):
        '''

        :param group:
        :param adict:

        :param first_only:
            Include only first result.
        '''
        keys = []
        group = self.get_argument_group(group)
        for action in group._group_actions:  # pylint: disable=W0212
            if adict:
                key = self.get_action_key(action, adict)
                if key:
                    keys.append(key)

            else:
                for option_string in action.option_strings:
                    keys.append(option_string.lstrip('-'))

                    if first_only:
                        break

        return keys

    @staticmethod
    def get_action_key(action, adict):
        if action.option_strings:
            for option_string in action.option_strings:
                if option_string.lstrip('-') in adict:
                    return option_string.lstrip('-')

        elif action.dest in adict:
            return action.dest

        elif action.dest.replace('_', '-') in adict:
            return action.dest.replace('_', '-')

        return None

    def create_argv_list(self, _group, *varargs, **kwargs):
        '''
        Hopefully we can send (vmname, varargs, kwargs).

        Think best think to do is send parser (default, salt, keywords) with
        varargs and  kwargs; parse on that.

        Only need to return argv since functions will have access to complete
        var set.

        Maybe use DictDiffer if we need to remove items, like defaults...

        :param _group:
        '''
        group = _group
        hide = self.options.get('hide', []) or None
        keyword_flag_keys = self.options.get('flags', {})

        info = {}
        info['__args'] = None
        info['__varargs'] = varargs
        info['__keywords'] = kwargs
        info['__flags'] = []
        info['_argparse_args'] = []
        info['_argparse_varargs'] = []
        info['_argparse_keywords'] = []
        info['_argparse_flags'] = []
        info['_argparse_skipped'] = []
        info['__argv'] = []
        info['__argv_hidden'] = []

        def add(dest, value):
            if value and isinstance(value, list):
                info['__argv'].extend(value)

                if hide is not None and dest not in hide:
                    info['__argv_hidden'].extend(value)
            else:
                info['__argv'].append(value)

                if hide is not None and dest not in hide:
                    info['__argv_hidden'].append(value)

        group = self.get_argument_group(group)
        varargs_index = 0

        for action in group._group_actions:  # pylint: disable=W0212
            dest = action.dest
            positional = not action.option_strings
            key = self.get_action_key(action, kwargs)

            if key and self.options.get('pop', None):
                value = kwargs.pop(key)

            elif key:
                value = kwargs.get(key)

            else:
                value = None

            # varargs
            if positional:
                if key:
                    add(dest, coerce_to_string(value))

                elif varargs and varargs_index < len(varargs):
                    add(dest, coerce_to_string(varargs[varargs_index]))
                    varargs_index += 1

            # kwargs
            else:

                # flags
                for flag_key in keyword_flag_keys:
                    flags = kwargs.get(flag_key, {})
                    if flags:
                        flag = self.get_action_key(action, flags)
                        if flag:
                            if isinstance(flag, str):
                                add(dest, '--{0}'.format(flag))
                            continue

                if not key:
                    continue

                # kwargs
                if key.startswith('--'):
                    add(dest, key)

                else:
                    add(dest, '--{0}'.format(key))

                if isinstance(value, list) and value:
                    add(dest, value)

                elif isinstance(value, types.FunctionType):
                    add(dest, ArgparseFunctionWrapper(value))

                else:
                    add(dest, coerce_to_string(value))

        return info
