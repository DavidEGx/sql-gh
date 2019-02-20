__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import psycopg2
from sqlgh.dbrunner.base import DBRunnerBase


class DBRunnerPostgreSQL(DBRunnerBase):
    """
    Execute exams in PostgreSQL database.
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

        self._execute_solved(schema, solved)
        for exam in (students):
            self._execute_student(solved, exam)

    def _execute_solved(self, schema, solved):
        log.info("Generating database from {}".format(schema))
        with open(schema, 'r') as f:
            schema_txt = f.read()

        dbname = self._db_name("solved")

        conn = psycopg2.connect(host=self.host,
                                port=self.port,
                                user=self.user,
                                password=self.password,
                                dbname="postgres")
        conn.set_session(autocommit=True)

        cur = conn.cursor()
        cur.execute("DROP DATABASE IF EXISTS {};".format(dbname))
        cur.execute("CREATE DATABASE {};".format(dbname))
        cur.close()
        conn.close()

        conn = psycopg2.connect(host=self.host,
                                port=self.port,
                                user=self.user,
                                password=self.password,
                                dbname=dbname)
        conn.set_session(autocommit=True)

        cur = conn.cursor()
        cur.execute(schema_txt)
        cur.close()
        conn.close()

        log.info("Running solved exam sql code")
        for i, exercise in enumerate(solved.exercises):
            previous_db = self._db_name("solved", i)
            current_db  = self._db_name("solved", i + 1)

            conn = self._copy_db(previous_db, current_db)
            cur  = conn.cursor()
            try:
                cur.execute(exercise.solution)
                if (exercise.test):
                    cur.execute(exercise.test)

                exercise.x_data = cur.fetchall()

            except Exception as e:
                log.critical("Couldn't run exercise {}".format(i + 1))
                log.critical(e)

            conn.commit()
            cur.close()
            conn.close()

    def _execute_student(self, solved, exam):
        log.info("Running {} sql code".format(exam.student))

        for i, exercise in enumerate(exam.exercises):
            base_db     = self._db_name("solved", i)
            current_db  = self._db_name(exam.student, i)

            conn = self._copy_db(base_db, current_db)
            cur  = conn.cursor()
            try:
                cur.execute(exercise.answer)
                exercise.x_runs_ok = True

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
                exercise.x_error   = e

            conn.commit()
            cur.close()
            conn.close()

    def _db_name(self, name, idx=0):
        project = self.project
        return "sqlgh_{}_{}_{}".format(project.name, name, idx)

    def _copy_db(self, src, dest):
        conn = psycopg2.connect(host=self.host,
                                port=self.port,
                                user=self.user,
                                password=self.password,
                                dbname="postgres")
        conn.set_session(autocommit=True)

        cur = conn.cursor()
        cur.execute("DROP DATABASE IF EXISTS {};".format(dest))
        cur.execute("CREATE DATABASE {} WITH TEMPLATE {};".format(dest, src))
        cur.close()
        conn.close()

        conn = psycopg2.connect(host=self.host,
                                port=self.port,
                                user=self.user,
                                password=self.password,
                                dbname=dest)
        conn.set_session(autocommit=True)
        return conn
