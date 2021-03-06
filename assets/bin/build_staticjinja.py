#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""staticjinja
Usage:
  staticjinja build [--srcpath=<srcpath> --outpath=<outpath> --static=<a,b,c>]
  staticjinja watch [--srcpath=<srcpath> --outpath=<outpath> --static=<a,b,c>]
  staticjinja (-h | --help)
  staticjinja --version
Options:
  -h --help     Show this screen.
  --version     Show version.
"""

from __future__ import print_function
from docopt import docopt
import gettext
import os
import staticjinja
import sys

import babel.dates
import dateparser

def get_translation(domain, fallback):
    try:
        translation = gettext.translation(domain, 'locale', fallback=fallback, codeset='utf-8')
    except IOError:
        pass
    else:
        return translation

def translation():
    translation = get_translation('text', True)
    translation.install(unicode=True, names=['gettext', 'ngettext'])
    return translation

def render(args):
    """
    Render a site.
    :param args:
        A map from command-line options to their values. For example:
            {
                '--help': False,
                '--outpath': None,
                '--srcpath': None,
                '--static': None,
                '--version': False,
                'build': True,
                'watch': False
            }
    """
    srcpath = (
        os.path.join(os.getcwd(), 'templates') if args['--srcpath'] is None
        else args['--srcpath'] if os.path.isabs(args['--srcpath'])
        else os.path.join(os.getcwd(), args['--srcpath'])
    )

    if not os.path.isdir(srcpath):
        print("The templates directory '%s' is invalid."
              % srcpath)
        sys.exit(1)

    if args['--outpath'] is not None:
        outpath = args['--outpath']
    else:
        outpath = os.getcwd()

    if not os.path.isdir(outpath):
        print("The output directory '%s' is invalid."
              % outpath)
        sys.exit(1)

    staticdirs = args['--static']
    staticpaths = None

    if staticdirs:
        staticpaths = staticdirs.split(",")
        for path in staticpaths:
            path = os.path.join(srcpath, path)
            if not os.path.isdir(path):
                print("The static files directory '%s' is invalid." % path)
                sys.exit(1)

    site = staticjinja.make_site(
        filters={
          # http://unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns
          # http://babel.pocoo.org/en/latest/dates.html
          'dt': lambda s, f: babel.dates.format_datetime(dateparser.parse(s), f),
        },
        searchpath=srcpath,
        outpath=outpath,
        extensions=['jinja2.ext.i18n'],
        staticpaths=staticpaths
    )
    site._env.install_gettext_translations(translation())

    use_reloader = args['watch']

    site.render(use_reloader=use_reloader)


def main():
    render(docopt(__doc__, version='staticjinja 0.3.0'))


if __name__ == '__main__':
    main()
