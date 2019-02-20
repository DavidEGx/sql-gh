__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import mysql.connector
from sqlgh.dbrunner.base import DBRunnerBase


class DBRunnerMySQL(DBRunnerBase):
    """
    Execute exams in MySQL database.
    See parent `DBRunner` for more information.
    """
    def __init__(self, project, *, rdbms, host, port, user, password):
        DBRunnerBase.__init__(self, project, rdbms=rdbms
                                           , host=host
                                           , port=port
                                           , user=user
                                           , password=password)

    def execute(self):
        schema   = self.project.schema_file
        solved   = self.project.solved_exam
        students = self.project.student_exams

        log.info("Generating database from {}".format(schema))
        with open(schema, 'r') as f:
            schema = f.read()

        conn = mysql.connector.connect(host=self.host,
                                       port=self.port,
                                       user=self.user,
                                       password=self.password)

        cur = conn.cursor(buffered=True)

        # Create all databases
        # This is a bit slow because we need to create as many databases as
        # (number of exercises * (number of exams + 1)).
        db_names = ['solved'] + [exam.student for exam in students]
        for i, exercise in enumerate(solved.exercises):
            for name in db_names:
                dbname = self._db_name(name, i)
                log.info("Creating database {}".format(dbname))

                # Create database
                cur.execute("DROP DATABASE IF EXISTS {}".format(dbname))
                cur.execute("CREATE DATABASE {}".format(dbname))
                conn.database = dbname

                # Create tables and initial data
                for result in cur.execute(schema, multi=True):
                    pass

                # Alter status for each exercise
                for ii in range(-1, i):
                    log.debug('Running exercise {}'.format(ii + 2))
                    iexercise = solved.exercises[ii + 1]
                    try:
                        cur.execute(iexercise.solution)
                    except Exception as e:
                        log.critical("Couldn't run exercise {}".format(ii + 2))
                        log.critical(e)
        conn.close()

        # Get data for solved exam
        for i, exercise in enumerate(solved.exercises):
            dbname = self._db_name('solved', i)
            conn = mysql.connector.connect(host=self.host,
                                           port=self.port,
                                           user=self.user,
                                           password=self.password,
                                           database=dbname)
            cur = conn.cursor(buffered=True)

            try:
                if (exercise.test):
                    cur.execute(exercise.test)
                    exercise.x_data = cur.fetchall()
                else:
                    cur.execute(exercise.solution)
                    exercise.x_data = cur.fetchall()
            except Exception as e:
                log.critical("Couldn't run exercise {}".format(i + 1))
                log.critical(e)

            conn.close()

        # Get data for students
        for exam in students:
            for i, exercise in enumerate(exam.exercises):
                dbname = self._db_name(exam.student, i)
                conn = mysql.connector.connect(host=self.host,
                                               port=self.port,
                                               user=self.user,
                                               password=self.password,
                                               database=dbname)
                cur = conn.cursor(buffered=True)

                try:
                    cur.execute(exercise.answer)
                    exercise.x_runs_ok = True
                    exercise.x_data    = cur.fetchall()

                    solved_ex = solved.exercises[i]
                    if (solved_ex.test):
                        cur.execute(solved_ex.test)
                        exercise.x_data = cur.fetchall()

                    exercise.x_identical    = exercise.x_data == solved_ex.x_data
                    exercise.x_col_number   = exercise.col_number() == solved_ex.col_number()
                    exercise.x_row_number   = exercise.row_number() == solved_ex.row_number()
                    exercise.x_ignore_order = (set(exercise.x_data) == set(solved_ex.x_data)
                                               and exercise.x_row_number)
                except Exception as e:
                    log.error("Couldn't run exercise {} for exam {}".
                              format(i + 1, exam.student))
                    log.error(e)

                    exercise.x_runs_ok = False
                    exercise.x_error   = str(e).replace("\n", "\n--                  ")

                conn.close()

    def _db_name(self, name, idx=0):
        project = self.project
        return "sqlgh_{}_{}_{}".format(project.name, name, idx)
