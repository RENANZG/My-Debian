# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       qubes
:platform:      all

======================
Misc Utility Functions
======================
'''

from __future__ import absolute_import

# Import python libs
import argparse  # pylint: disable=E0598
import collections
import logging

from inspect import stack

# Salt libs
import salt.utils

# Enable logging
log = logging.getLogger(__name__)


# pylint: disable=E1101
class Status(argparse.Namespace):
    def __init__(self, *args, **kwargs):  # pylint: disable=W0613
        defaults = {
            'name': '',
            'result': None,
            'retcode': 0,
            'stdout': '',
            'stderr': '',
            'data': None,
            'changes': {},
            'comment': '',
            'prefix': '',
            'message': '',
            'error_message': '',
        }

        defaults.update(kwargs)
        super(Status, self).__init__(**defaults)

    def __len__(self):
        return self.passed()

    def reset(self, key, default=None):
        value = getattr(self, key, default)
        self[key] = type(self[key])()  # pylint: disable=E1136
        return value

    def passed(self, **kwargs):  # pylint: disable=W0613
        '''
        'result' or 'retcode' are the indicators of a successful status.

        If 'result' is not None that value is used and 'retcode' ignored
        which allows retcode to be overridden if needed.  If 'result' is None
        the value from 'retcode' is used to determine a pass or fail.

        'retcode': 0 == pass / 1+ == fail (usually a shell return code)
        'result':  True == pass / False == fail / None == Unused
        '''
        return self.result if self.result is not None else not bool(
            self.retcode
        )

    def failed(self, **kwargs):  # pylint: disable=W0613
        return not self.result if self.result is not None else bool(
            self.retcode
        )

    # pylint: disable=W0613
    def _format(
        self,
        name=None,
        retcode=None,
        result=None,
        data=None,
        prefix=None,
        message='',
        error_message=''
    ):
        '''Combines argument variables and formats the status.

        Copy args to status. Passed args override status set args.
        '''
        args = [
            'name', 'retcode', 'result', 'data', 'prefix', 'message',
            'error_message'
        ]

        for arg in args:
            if arg not in self or locals().get(arg, None):
                setattr(self, arg, locals()[arg])

        if not self.comment:  # pylint: disable=E0203
            # ------------------------------------------------------------------
            # Create comment
            # ------------------------------------------------------------------
            prefix = self.prefix if 'prefix' in self else ''
            message = self.message if 'message' in self else ''
            error_message = self.error_message if 'error_message' in self else ''

            if prefix is None:
                prefix = '[FAIL] ' if self.failed() else '[PASS] '
            indent = ' ' * len(prefix)

            # Manage message
            if self.failed():
                if error_message:
                    message = error_message

            if not message:
                indent = ''
                message = message.strip()

            stdout = stderr = ''
            if self.failed() and self.stderr.strip():
                if message:
                    stderr += '{0}{1}'.format(prefix, message)

                if self.stdout.strip():
                    stderr += '\n{0}{1}'.format(
                        indent, self.stdout.strip().replace(
                            '\n', '\n' + indent
                        )
                    )

                if self.stderr.strip():
                    stderr += '\n{0}{1}'.format(
                        indent, self.stderr.strip().replace(
                            '\n', '\n' + indent
                        )
                    )

            else:
                if message:
                    stdout += '{0}{1}'.format(prefix, message)

                if self.stdout.strip():
                    stdout += '\n{0}{1}'.format(
                        indent, self.stdout.strip().replace(
                            '\n', '\n' + indent
                        )
                    )

            if stderr:
                if stdout:
                    stdout = '====== stdout ======\n{0}\n\n'.format(stdout)
                stderr = '====== stderr ======\n{0}'.format(stderr)

            self.comment = stdout + stderr  # pylint: disable=W0201

            return self

    def _finalize(
        self, data=None,
        status_mode='last',
        cli_mode=False,
        debug_mode=False,
        test_mode=False
    ):
        '''
        Merges provided list of status and prepares status
        for return to salt.

        Additional messages may be appended to stdout.

        data:
            List of status to merge.

        status_mode:
            'all' or 'last'. last only uses last retcode to determine overall
            success where all will fail on first failure code.

        cli_mode:
            True if called by commandline interface, otherwise False.

        debug_mode:
            Merges all status messages.

        test_mode:
            True if test mode is enabled, otherwise False.
        '''
        if data is None:
            data = []

        def linefeed(text):
            return '\n' if text else ''

        comment = ''
        changes = {}

        if not data:
            data = [self]

        index = retcode = 0
        if status_mode in ['last']:
            status = data[-1]
            retcode = status.retcode

            if status.result is not None:
                retcode = not status.result

            if status.passed():
                index = -1

        if debug_mode:
            index = 0

        # ----------------------------------------------------------------------
        # Determine 'retcode' and merge 'comments' and 'changes'
        # ----------------------------------------------------------------------
        for status in data[index:]:
            # 'comment' - Merge comment
            if status.comment.strip():
                comment += linefeed(comment) + status.comment

            # 'retcode' - Determine retcode
            # Use 'result' over 'retcode' if result is not None as 'retcode'
            # reflects last run state, where 'result' is set explicitly
            if status.result is not None:
                retcode = not status.result

            elif status.retcode and status_mode in ['all']:
                retcode = status.retcode

            if status.result and test_mode:
                status.result = None

            elif test_mode:
                status.result = None if not retcode else False

            else:
                status.result = True if not retcode else False

            # 'changes' - Merge changes
            if status.changes and status.passed():
                name = getattr(status, 'name', '')  # or self.__virtualname__
                changes.setdefault(name, {})

                for key, value in status.changes.items():
                    changes[name][key] = value

        # Only include last comment unless status failed
        if not debug_mode and status_mode in ['last'] and not retcode:
            comment = status.comment

        # If called by CLI only return stdout
        if cli_mode:
            return dict(
                retcode=retcode,
                stdout=status.stdout or comment,
                stderr=status.stdout,
            )

        return Status(
            name=status.name,
            retcode=retcode,
            result=status.result,
            comment=comment,
            stdout=status.stdout,
            stderr=status.stdout,
            changes=changes,
        )


def coerce_to_string(value):
    '''
    Convert value to string when possible (for argparse).

    :param value:
    '''
    if value is None:
        value = ''

    elif isinstance(value, list):
        value = ' '.join(value)

    else:
        value = str(value)

    return value


def coerce_to_list(value):
    '''
    Converts value to a list.

    :param value:
    '''
    if not value:
        value = []

    elif isinstance(value, str):
        value = [value, ]

    elif isinstance(value, tuple):
        value = list(value)

    return value


def get_fnargs(function, **kwargs):
    '''
    Returns all args that a function uses along with default values.

    :param function:
    '''
    fnargs = salt.utils.arg_lookup(function).values()[1]
    for key, value in kwargs.items():
        if key in fnargs:
            fnargs[key] = value
    return fnargs


def function_alias(new_name):
    '''
    Creates a generated function alias that initializes decorator class then
    calls the instance and returns any values.

    Doc strings are also copied to wrapper so they are available to salt command
    line interface via the --doc option.

    :param new_name:
    '''
    def outer(func):
        frame = stack()[0][0]
        func_globals = frame.f_back.f_globals

        if '__virtualname__' in func_globals:
            func.__virtualname__ = '{0}.{1}'.format(
                func_globals['__virtualname__'], new_name
            )

        def wrapper(*varargs, **kwargs):
            module = func(*varargs, **kwargs)
            return module()

        wrapper.func = func

        if 'usage' in dir(func):
            wrapper.__doc__ = func.usage()

        else:
            wrapper.__doc__ = func.__doc__

        wrapper.__name__ = new_name
        func_globals_save = {new_name: wrapper}
        func_globals.update(func_globals_save)
        return func

    return outer


def update(target, source, create=False, allowed=None, append=False):
    '''
    Updates the values of a nested dictionary of varying depth without over-
    writing the targets root nodes.

    :param target:
        Target dictionary to update.

    :param source:
        Source dictionary that will be used to update `target`.

    :param create:
        If True then new keys can be created during update, otherwise they will
        be tossed if they do not exist in `target`.

    :param allowed:
        List of allowed keys that can be created even if create is False.

    :param append:  [True] or ['list_of_keys', 'key4']
        Appends to strings or lists if append is True or key in list.
    '''
    if not allowed:
        allowed = []

    for key, value in source.items():
        if isinstance(value, collections.Mapping):
            if key in target.keys() or create or key in allowed:
                replace = update(
                    target.get(key, {}),
                    value,
                    create=create,
                    allowed=allowed,
                    append=append
                )
                target[key] = replace

        else:
            if key in target.keys() or create or key in allowed:
                if append and (append is True or key in append):
                    if isinstance(source[key], str) and isinstance(
                        target.get(key, ''), str
                    ):
                        target.setdefault(key, '')
                        target[key] += source[key]

                    elif isinstance(source[key], list) and isinstance(
                        target.get(key, []), list
                    ):
                        target.setdefault(key, [])
                        target[key].extend(source[key])

                    else:
                        target[key] = source[key]

                else:
                    target[key] = source[key]

    return target
