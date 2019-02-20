__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import json
import os
from pathlib import Path

SUPPORTED_DATABASES = {
    'sqlite'   : 0,
    'mysql'    : 3306,
    'postgres' : 5432
    # 'oracle': 1521
    # 'sqlserver': 1433
}


class Config:
    '''Manages application configuration'''

    def __init__(self):
        try:
            with open(self.config_file, "r") as f:
                data = f.read()
                self.config = json.loads(data)
        except FileNotFoundError:
            log.debug('Creating config file')
            self.config = {
                "default": {
                    "host": "127.0.0.1",
                    "port": 0,
                    "rdbms": "sqlite"
                }
            }

            os.mkdir(self.base_dir)
            os.mkdir(self.projects_dir)
            with open(self.config_file, "w") as f:
                f.write(json.dumps(self.config, sort_keys=True, indent=2))

    @property
    def base_dir(self):
        '''Return the directory where sql-gh config is stored'''
        return "{}{}{}".format(Path.home(), os.path.sep, '.sql-gh')

    @property
    def projects_dir(self):
        '''Return directory where projects are stored'''
        return "{}{}{}".format(self.base_dir, os.path.sep, 'projects')

    @property
    def config_file(self):
        '''Return location of config file'''
        return "{}{}{}".format(self.base_dir, os.path.sep, 'config.json')

    @property
    def supported_databases(self):
        '''Return supported rdbms'''
        return list(SUPPORTED_DATABASES.keys())

    @property
    def projects(self):
        '''Return available projects'''
        return [p for p in os.listdir(self.projects_dir) if not p.startswith('.')]

    @property
    def databases(self):
        '''Return available databases'''
        return list(self.config.keys())

    def database(self, db):
        '''Return information for a database'''
        return self.config[db]

    def add_database(self, *, name, host, port=None, rdbms, user=None, password=None):
        '''Adds a database to the configuration'''
        if rdbms not in SUPPORTED_DATABASES:
            log.critical("Unsupported rdbms '{}'".format(rdbms))
            return

        name = name.replace(' ', '_')
        if name in (self.config):
            log.critical("Name '{}' already in use".format(name))
            return

        port = port or SUPPORTED_DATABASES[rdbms]

        self.config[name] = {
            "rdbms"   : rdbms,
            "host"    : host,
            "port"    : port,
            "user"    : user,
            "password": password
        }
        with open(self.config_file, "w") as f:
            f.write(json.dumps(self.config, sort_keys=True, indent=2))

        log.info("Database '{}' added".format(name))

    def remove_database(self, name):
        '''Remove a database from the system'''
        if name in self.config:
            self.config.pop(name)

            with open(self.config_file, "w") as f:
                f.write(json.dumps(self.config, sort_keys=True, indent=2))

            log.info("Database '{}' removed".format(name))
        else:
            log.critical("Database '{}' does not exist".format(name))
