__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import re
from sqlgh.exam.base import BaseExam
from sqlgh.exercise.solved import SolvedExercise

re_array = {
    'question': re.compile(r'-->\s+\d+'),
    'solution': re.compile(r'-->\s+Solution:'),
    'test'    : re.compile(r'-->\s+Test:'),
    'include' : re.compile(r'-->\s+Include:'),
    'exclude' : re.compile(r'-->\s+Exclude:')
}
re_start = re_array['question']


class SolvedExam(BaseExam):
    """Represents an exam solved by a teacher"""

    def to_template_file(self, filename):
        with open(filename, 'w', encoding="utf8") as f:
            f.write(self.header)
            for i, e in enumerate(self.exercises):
                f.write('--> {}\n{}\n--> Answer: \n\n\n\n\n\n'.format(i + 1, e.question))

    @classmethod
    def from_string(cls, txt):

        my_exam = SolvedExam(header='', student='', exercises=[])

        exercise = None
        key = None

        for i, line in enumerate(txt.splitlines()):
            if (line.strip().startswith("#") or line.strip().startswith("-- #")):
                next

            if (re_start.match(line)):
                if exercise:
                    my_exam.add_exercise(SolvedExercise(
                        question  = exercise['question'].strip(),
                        solution = exercise['solution'].strip(),
                        test     = exercise['test'].strip(),
                        include  = exercise['include'].strip(),
                        exclude  = exercise['exclude'].strip(),
                    ))

                exercise = {
                    'question'  : '',
                    'solution' : '',
                    'test'     : '',
                    'include'  : '',
                    'exclude'  : ''
                }
                key = 'question'

            for k, regex in re_array.items():
                if (regex.match(line)):
                    key = k
                    break
            else:
                if exercise and key:
                    exercise[key] += line + '\n'
                else:
                    my_exam.header += line + '\n'

        if exercise:
            my_exam.add_exercise(SolvedExercise(
                question  = exercise['question'].strip(),
                solution = exercise['solution'].strip(),
                test     = exercise['test'].strip(),
                include  = exercise['include'].strip(),
                exclude  = exercise['exclude'].strip(),
            ))
        return my_exam

    @classmethod
    def from_file(cls, filename):
        log.debug("Getting solved exam from file {}".format(filename))
        with open(filename, 'r', encoding="utf8") as f:
            txt = f.read()
            return cls.from_string(txt)
