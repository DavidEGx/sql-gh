__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import logging as log
import ntpath
import re
from sqlgh.exam.base import BaseExam
from sqlgh.exercise.student import StudentExercise

re_array = {
    'question'  : re.compile(r'-->\s+\d+'),
    'answer'    : re.compile(r'-->\s+Answer\s*:'),
}


class StudentExam(BaseExam):

    def to_file(self, filename):
        with open(filename, 'w', encoding="utf8") as f:
            f.write(self.header)
            f.write("\n{}\n".format("-" * 80))
            f.write("--> TOTAL SCORE: {}\n".format(self.total_score))
            f.write("{}\n\n".format("-" * 80))

            for i, e in enumerate(self.exercises):
                f.write('--> {}\n'.format(i + 1))
                f.write('--> Score: {}\n'.format(e.score))
                if (e.feedback):
                    f.write('--> Feedback: {}\n'.format(e.feedback))
                f.write('{}\n'.format(e.question))
                f.write('--> Answer:\n{}\n\n\n'.format(e.answer))

    @classmethod
    def from_string(cls, txt):

        my_exam  = cls(exercises=[])
        key      = None
        exercise = None

        for i, line in enumerate(txt.splitlines()):

            if (re_array['question'].match(line)):
                key = 'question'
                if exercise:
                    answer = exercise['answer'].strip()
                    question = exercise['question'].strip()
                    my_exam.add_exercise(
                        StudentExercise(question=question, answer=answer))

                exercise = {'answer' : '', 'question': ''}
            elif (re_array['answer'].match(line)):
                key = 'answer'
            elif (exercise):
                exercise[key] += line + '\n'
            else:
                my_exam.header += line + '\n'

        if exercise:
            answer = exercise['answer'].strip()
            question = exercise['question'].strip()
            my_exam.add_exercise(StudentExercise(question=question, answer=answer))

        return my_exam

    @classmethod
    def from_file(cls, filename):
        log.debug("Getting student exam from file {}".format(filename))
        try:
            with open(filename, 'r', encoding='utf8') as f:
                txt = f.read()
        except UnicodeDecodeError:
            with open(filename, 'r', encoding='latin-1') as f:
                txt = f.read()

        exam = cls.from_string(txt)
        exam.student = ntpath.basename(filename).replace('.sql', '').replace(' ', '_')
        log.info("{} exercises found for student '{}'"
                 .format(len(exam.exercises), exam.student))
        return exam

    @property
    def total_score(self):
        return sum([e.score for e in self.exercises])

    def __str__(self):
        return self.student
