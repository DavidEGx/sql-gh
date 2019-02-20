__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import os
import shutil
import sqlite3
from sqlgh.dbrunner.base import DBRunnerBase


class DBRunnerSQLite(DBRunnerBase):
    """
    Execute exams in SQLite database.
    See parent `DBRunner` for more information.
    """
    def __init__(self, project, *, rdbms, host, port, user=None, password=None):
        DBRunnerBase.__init__(self, project, rdbms=rdbms
                                           , host=host
                                           , port=port
                                           , user=user
                                           , password=password)

    def execute(self):
        schema   = self.project.schema_file
        solved   = self.project.solved_exam
        students = self.project.student_exams

        # First empty tmp directory
        tmpdir = "{}{}{}".format(self.project.base_dir, os.path.sep, "sqlite")
        shutil.rmtree(tmpdir, ignore_errors=True)
        os.mkdir(tmpdir)

        # Now execute
        self._execute_solved(schema, solved)
        for exam in (students):
            self._execute_student(solved, exam)

    def _execute_solved(self, schema, solved):
        log.info("Generating database from {}".format(schema))
        with open(schema, 'r') as f:
            schema = f.read()

        conn = sqlite3.connect(self._db_name("solved", 0), isolation_level=None)
        conn.executescript(schema)
        conn.close()

        log.info("Running solved exam sql code")
        for i, exercise in enumerate(solved.exercises):
            previous_db = self._db_name("solved", i)
            current_db  = self._db_name("solved", i + 1)
            shutil.copy(previous_db, current_db)

            conn = sqlite3.connect(current_db, isolation_level=None)
            cur  = conn.cursor()
            try:
                cur.execute(exercise.solution)
                exercise.x_data = cur.fetchall()
                if (exercise.test):
                    cur.execute(exercise.test)
                    exercise.x_data = cur.fetchall()

            except Exception as e:
                log.critical("Couldn't run exercise {}".format(i + 1))
                log.critical(e)

    def _execute_student(self, solved, exam):
        log.info("Running {} sql code".format(exam.student))

        for i, exercise in enumerate(exam.exercises):
            base_db     = self._db_name("solved", i)
            current_db  = self._db_name(exam.student, i)
            shutil.copy(base_db, current_db)

            conn = sqlite3.connect(current_db, isolation_level=None)
            cur  = conn.cursor()
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
                exercise.x_error   = e

    def _db_name(self, name, idx):
        project = self.project
        stem = "{}{}sqlite{}{}".format(project.base_dir, os.path.sep
                                       , os.path.sep, project.name)
        return "{}_{}_{}.db".format(stem, name, idx)
