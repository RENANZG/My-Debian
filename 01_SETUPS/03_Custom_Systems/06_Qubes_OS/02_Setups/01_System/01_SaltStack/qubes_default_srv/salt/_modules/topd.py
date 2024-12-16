# -*- coding: utf-8 -*-
#
# vim: set ts=4 sw=4 sts=4 et :
'''
:maintainer:    Jason Mehring <nrgaway@gmail.com>
:maturity:      new
:depends:       none
:platform:      all
'''

from __future__ import absolute_import

# Import python libs
import fnmatch
import logging

# Import salt libs
import salt.fileclient
import salt.loader
import salt.template
import salt.version

from salt.exceptions import SaltRenderError
from salt.utils.odict import (OrderedDict, DefaultOrderedDict)

# Import custom libs
from toputils import TopUtils  # pylint: disable=E0401

# Enable logging
log = logging.getLogger(__name__)

try:
    __context__['salt.loaded.ext.module.top'] = True
except NameError:
    __context__ = {}

# Define the module's virtual name
__virtualname__ = 'top'
version = salt.version.__saltstack_version__


def __virtual__():
    '''
    '''
    return __virtualname__


def toputils():
    return TopUtils(__opts__)


def enabled(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).enabled(paths, saltenv)


def disabled(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).disabled(paths, saltenv)


def is_enabled(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).is_enabled(paths, saltenv)


def enable(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).enable(paths, saltenv)


def disable(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).disable(paths, saltenv)


def report(*varargs, **kwargs):
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)
    return TopUtils(__opts__, **kwargs).report(paths, saltenv)


def status(*varargs, **kwargs):
    '''
    List status of one or all top files.  If saltenv is not provided, all
    environments will be searched
    '''
    paths = kwargs.get('paths', varargs)
    saltenv = kwargs.get('saltenv', None)

    if paths or saltenv:
        return TopUtils(__opts__, **kwargs).tops(paths, saltenv)
    else:
        return TopUtils(__opts__, **kwargs).report()


def get_opts(opts=None):
    if not opts:
        opts = __opts__
    return opts


def get_renderers(opts=None, pillar=False):
    if 'renderers' in __context__:
        return __context__['renderers']

    opts = get_opts(opts)
    renderers = salt.loader.render(opts, salt.loader.minion_mods(opts), pillar)

    # For salt versions less than 2015.8
    if version.info < (2015, 8, 0, 0):
        jinja = renderers.get('jinja', None)
        if jinja and not jinja.__globals__.get('__grains__', None):
            jinja.__globals__['__grains__'] = __grains__

    __context__['renderers'] = renderers
    return renderers


def get_fileclient(opts=None, pillar=False):
    opts = get_opts(opts)
    return salt.fileclient.get_file_client(opts, pillar)


def get_environment(pillar):
    if pillar:
        return 'pillarenv'
    else:
        return 'environment'


def get_envs(opts=None):
    '''
    Pull the file server environments out of the master options
    :param opts:
    '''
    opts = get_opts(opts)
    envs = {'base'}
    if 'file_roots' in opts:
        envs.update(list(opts['file_roots']))
    return envs


def render(path, opts=None, saltenv='base', sls='', pillar=False):
    opts = get_opts(opts)
    client = get_fileclient(opts, pillar=pillar)
    template = client.cache_file(path, saltenv)

    if template:
        renderers = get_renderers(opts, pillar)

        salt_data = salt.template.compile_template(
            template,
            renderers,
            opts['renderer'],
            blacklist=None,
            whitelist=None,
            saltenv=saltenv,
            sls=sls,
            _pillar_rend=pillar
        )
        return salt_data
    return OrderedDict()


def render_top(opts, toputils, pillar=False):  # pylint: disable=W0621
    '''
    Gather the top files
    :param toputils:
    :param opts:
    '''
    tops = DefaultOrderedDict(list)
    include = DefaultOrderedDict(list)
    done = DefaultOrderedDict(list)
    environment = get_environment(pillar=pillar)

    # Gather initial top files
    if opts['top_file_merging_strategy'] == 'same' and not opts[environment]:
        if not opts['default_top']:
            raise SaltRenderError(
                'Top file merge strategy set to same, but no default_top '
                'configuration option was set'
            )
        opts[environment] = opts['default_top']

    if opts.get(environment, None):
        salt_data = render(
            opts['state_top'],
            opts=opts,
            saltenv=opts[environment],
            pillar=pillar
        )
        if salt_data:
            tops[opts[environment]] = salt_data
    elif opts['top_file_merging_strategy'] == 'merge':
        if opts.get('state_top_saltenv', False):
            saltenv = opts['state_top_saltenv']
            salt_data = render(opts['state_top'], opts=opts, saltenv=saltenv, pillar=pillar)
            if salt_data:
                tops[saltenv].append(salt_data)
            else:
                log.debug('No contents loaded for env: {0}'.format(saltenv))
        else:
            for saltenv in get_envs(opts):
                salt_data = render(
                    opts['state_top'],
                    opts=opts,
                    saltenv=saltenv,
                    pillar=pillar
                )
                if salt_data:
                    tops[saltenv].append(salt_data)
                else:
                    log.debug(
                        'No contents loaded for env: {0}'.format(
                            saltenv
                        )
                    )

    # Search initial top files for includes
    for saltenv, ctops in tops.items():
        for ctop in ctops:
            if 'include' not in ctop:
                continue
            for sls in ctop['include']:
                include[saltenv].append(sls)
            ctop.pop('include')

    # Go through the includes and pull out the extra tops and add them
    while include:
        pops = []
        for saltenv, states in include.items():
            pops.append(saltenv)
            if not states:
                continue
            for sls_match in states:
                states = toputils.states(saltenv)
                for sls in fnmatch.filter(states[saltenv], sls_match):
                    if sls in done[saltenv]:
                        continue
                    salt_data = render(sls, opts=opts, saltenv=saltenv, pillar=pillar)
                    if salt_data:
                        tops[saltenv].append(salt_data)
                    else:
                        log.debug(
                            'No contents loaded for include {0} env: {1}'
                            .format(sls, saltenv)
                        )
                    done[saltenv].append(sls)
        for saltenv in pops:
            if saltenv in include:
                include.pop(saltenv)
    return tops


def merge_tops(tops):
    '''
    Cleanly merge the top files

    Top structure
    OrderedDict - str(saltenv)
        OrderedDict - str(target)
            list [(str state...}]
            list [(OrderedDict matches), (str state..)]

    :param tops:
    '''
    top = DefaultOrderedDict(OrderedDict)

    # List of complied tops
    for _top in tops:
        # Compiled tops of one tops file
        for ctops in _top.values():
            # Targets in a list
            for ctop in ctops:
                for saltenv, targets in ctop.items():
                    if saltenv == 'include':
                        continue
                    try:
                        for tgt in targets:
                            if tgt not in top[saltenv]:
                                top[saltenv][tgt] = ctop[saltenv][tgt]
                                continue
                            matches = []
                            states = set()
                            for comp in top[saltenv][tgt] + ctop[saltenv][tgt]:
                                if isinstance(
                                    comp, dict
                                ) and comp not in matches:
                                    matches.append(comp)
                                if isinstance(comp, str):
                                    states.add(comp)
                            top[saltenv][tgt] = matches
                            top[saltenv][tgt].extend(list(states))
                    except TypeError:
                        raise SaltRenderError(
                            'Unable to render top file. No targets found.'
                        )
    return top


def get_top(path=None, opts=None, saltenv='base', pillar=False):
    '''
    Returns all merged tops from path.

    :param saltenv:
    :param opts:
    :param path:
    '''
    opts = get_opts(opts)
    opts['grains'] = __grains__
    tops = []

    toputils = TopUtils(
        opts,
        pillar=pillar,
        topd_dir=path,
        saltenv=saltenv
    )  # pylint: disable=W0621
    enabled = toputils.enabled(
        saltenv=saltenv,
        view='raw'
    )  # pylint: disable=W0621

    try:
        for topinfo in enabled:
            opts['state_top_saltenv'] = saltenv
            opts['state_top'] = toputils.salt_path(topinfo)
            tops.append(render_top(opts, toputils, pillar=pillar))
        tops = dict(merge_tops(tops))
    except SaltRenderError:
        raise

    return tops
