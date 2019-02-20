__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import csv
import json
import logging as log
import re
import shutil
import os
from pathlib import Path
import textwrap
from sqlgh.exam.solved import SolvedExam
from sqlgh.exam.student import StudentExam
from sqlgh.dbrunner.factory import DBRunnerFactory


class Project:
    """
    Project that will hold ONE exam prepared by the teacher
    and ALL the exam answers of the students.
    """

    def __init__(self, name):
        """Create a new project"""
        self.name   = name
        self.config = {}
        self._solved_exam   = None
        self._student_exams = None

    @classmethod
    def create(cls, *, name, database, schema_file, solved_file):
        project = cls(name)

        project.config = {
            "connection": database,
        }

        # Create necessary directories
        os.mkdir(project.base_dir)
        os.mkdir(project.original_exams_dir)
        os.mkdir(project.hinted_exams_dir)
        os.mkdir(project.marked_exams_dir)

        # Copy files
        shutil.copy(schema_file, project.schema_file)
        shutil.copy(solved_file, project.solved_exam_file)

        # Generate template
        exam = SolvedExam.from_file(project.solved_exam_file)
        exam.to_template_file(project.template_file)

        # Write config to disk
        json_config = json.dumps(project.config, sort_keys=True, indent=2)
        with open(project.config_file, "w", encoding="utf8") as f:
            f.write(json_config)

        return project

    @classmethod
    def recover(cls, name):
        """Recovers project configuration from disk"""
        project = cls(name)
        with open(project.config_file, "r", encoding="utf8") as f:
            data = f.read()
        project.config = json.loads(data)

        return project

    @property
    def solved_exam(self):
        """Return exam solved by a teacher"""
        if (not self._solved_exam):
            self._solved_exam = SolvedExam.from_file(self.solved_exam_file)

        return self._solved_exam

    @property
    def student_exams(self):
        """Returns all the student exams for this project"""

        if (self._student_exams):
            return self._student_exams

        exams = []
        files = ["{}{}{}".format(self.original_exams_dir, os.path.sep, x)
                 for x in os.listdir(self.original_exams_dir)]

        for f in files:
            exam = StudentExam.from_file(f)
            exams.append(exam)

        self._student_exams = exams
        return exams

    def generate_mark_hints(self, autoscore=False):
        """
        Compare all the answers of the `StudentExam`s with the solutions
        provided in `SolvedExam`.
        With all this information generates a new file containing all
        the student answers plus data regarding the quality of the answer.
        """
        log.info('Generating mark hints')
        db = DBRunnerFactory.get(self)
        try:
            db.execute()
        except Exception as e:
            log.critical("Couldn't create database from schema file: {}".format(e))
            raise(e)

        ordered_exercises = []
        for exam in (self.student_exams):

            for i, e in enumerate(exam.exercises):
                if len(ordered_exercises) <= i:
                    ordered_exercises.append([])

                score = '<score>'
                if autoscore:
                    solved_exercise = self.solved_exam.exercises[i]
                    max_score       = solved_exercise.score

                    if e.x_identical:
                        score = max_score
                    elif e.x_ignore_order:
                        score = max_score * 0.75
                    else:
                        score = 0

                ordered_exercises[i].append(textwrap.dedent("""\
                    --> Exercise   : {}
                    --> Student    : {}
                    --> sql-gh info:
                    -->     Code executes  : {}
                    -->     Execution error: {}
                    -->     Result matches solution: {}
                    -->     Result matches solution ignoring order: {}
                    -->     Result contains same number of rows as solution: {}
                    -->     Result contains same number of cols as solution: {}
                    --> Score      : {}
                    --> Feedback   : <feedback>
                    --> Answer     :
                    {}


                """).format(i + 1, exam.student, e.x_runs_ok,
                            e.x_error, e.x_identical, e.x_ignore_order,
                            e.x_row_number, e.x_col_number, score, e.answer))

        with open(self.hinted_file, "w", encoding="utf8") as f:
            [[f.write(txt) for txt in e] for e in ordered_exercises]

    def parse_marks(self):
        """
        Given a single file with all the marks for all the students,
        will take the marks and put them into the individual files
        for each student.
        """
        log.info('Parsing marks')
        exams = {e.student: e for e in self.student_exams}

        re_array = {
            'exercise' : re.compile(r'--> Exercise *: ?(.*)'),
            'student'  : re.compile(r'--> Student *: ?(.*)'),
            'score'    : re.compile(r'--> Score *: ?(.*)'),
            'feedback' : re.compile(r'--> Feedback *: ?(.*)')
        }

        (current_exam, current_exercise, errors) = (None, None, False)

        with open(self.hinted_file, 'r', encoding="utf8") as f:
            lines = f.readlines()

        for i, l in enumerate(lines):
            if (re_array['exercise'].match(l)):
                try:
                    exercise_str = re_array['exercise'].match(l).group(1)
                    current_exercise = int(exercise_str)
                except Exception:
                    log.critical("Line {}: Cannot parse exercise number '{}' for '{}'"
                                 .format(i, exercise_str, current_exam))
                    errors = True

            elif (re_array['student'].match(l)):
                try:
                    exam_name = re_array['student'].match(l).group(1)
                    current_exam = exams[exam_name]
                except KeyError:
                    log.critical("Line {}: '{}' exam not found".format(i, exam_name))
                    errors = True

            elif (re_array['score'].match(l)):
                try:
                    score = re_array['score'].match(l).group(1)
                    current_exam.exercises[current_exercise - 1].score = float(score)
                    log.debug("Assigned score {} to '{}' (exercise {})"
                              .format(score, current_exam, current_exercise))
                except Exception as e:
                    log.critical("Line {}: Cannot assign score '{}' to '{}' (exercise {})"
                                 .format(i, score, current_exam, current_exercise))
                    errors = True

            elif (re_array['feedback'].match(l)):
                feedback = re_array['feedback'].match(l).group(1).strip()
                if feedback != '<feedback>' and feedback != '':
                    current_exam.exercises[current_exercise - 1].feedback = feedback
                    log.debug("Assigned feedback '{}' to '{}' (exercise {})"
                              .format(feedback, current_exam, current_exercise))

                # Reset
                current_exam     = None
                current_exercise = None

        if errors:
            log.critical('There were some critical errors. Please fix input file.')
            raise Exception('Errors found parsing {}. See log for details'
                            .format(self.hinted_file))

        with open(self.csv_summary_file, 'w') as csvfile:
            filewriter = csv.writer(csvfile)
            filewriter.writerow(['Student', 'Score'])

            for name, exam in exams.items():
                exam.to_file("{}{}{}".format(self.marked_exams_dir, os.path.sep, name))
                filewriter.writerow([exam.student, exam.total_score])

    @property
    def base_dir(self):
        '''Directory where this project is stored.'''
        return "{}{}{}{}projects{}{}".format(Path.home(), os.path.sep
                                             , '.sql-gh', os.path.sep
                                             , os.path.sep, self.name)

    @property
    def original_exams_dir(self):
        '''Directory where students exams are stored'''
        return "{}{}{}".format(self.base_dir, os.path.sep, "01_students_exams")

    @property
    def hinted_exams_dir(self):
        return "{}{}{}".format(self.base_dir, os.path.sep, "02_exercises_with_marks")

    @property
    def marked_exams_dir(self):
        '''Directory where the exams are stored once they have been marked'''
        return "{}{}{}".format(self.base_dir, os.path.sep, "03_graded_exams")

    @property
    def config_file(self):
        '''Path to json config file'''
        return "{}{}project.json".format(self.base_dir, os.path.sep)

    @property
    def schema_file(self):
        '''Path to schema file. The file that contains the database structure and data.'''
        return "{}{}{}".format(self.base_dir, os.path.sep, "schema.sql")

    @property
    def solved_exam_file(self):
        '''Path to exam solved by the teacher'''
        return "{}{}{}".format(self.base_dir, os.path.sep, "exam_solved.sql")

    @property
    def hinted_file(self):
        '''Path to file containing all students ansers with hints generated by sql-gh.'''
        return "{}{}exercises_with_hints.sql".format(self.hinted_exams_dir, os.path.sep)

    @property
    def template_file(self):
        '''Path to template file.'''
        return "{}{}{}".format(self.base_dir, os.path.sep, "exam_template.sql")

    @property
    def csv_summary_file(self):
        '''Path to csv file containing students' scores'''
        return "{}{}{}".format(self.base_dir, os.path.sep, 'scores.csv')
