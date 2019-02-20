__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

from sqlgh.config import Config
from sqlgh.dbrunner.sqlite import DBRunnerSQLite
from sqlgh.dbrunner.mysql import DBRunnerMySQL
from sqlgh.dbrunner.postgresql import DBRunnerPostgreSQL


class DBRunnerFactory():
    @classmethod
    def get(cls, project):
        """
        Get the appropriate DBRunner upon configuration.
        """
        config  = Config()
        db_info = config.database(project.config['connection'])
        rdbms   = db_info['rdbms']

        if (rdbms == 'sqlite'):
            return DBRunnerSQLite(project, **db_info)
        elif (rdbms == 'mysql'):
            return DBRunnerMySQL(project, **db_info)
        elif (rdbms == 'postgres'):
            return DBRunnerPostgreSQL(project, **db_info)
        else:
            raise Exception("Unsupported rdbms '{}'".format(rdbms))
