__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'


class BaseExam:
    def __init__(self, header='', student='', exercises=[]):
        self.header    = header
        self.student   = student
        self.exercises = exercises

    def add_exercise(self, exercise):
        self.exercises.append(exercise)

    def parse_template():
        pass

    def parse_exam():
        pass

    def config(self):
        return {
            'header'   : self.header,
            'student'  : self.student,
            'exercises': self.exercises
        }
