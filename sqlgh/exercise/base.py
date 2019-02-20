__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'


class BaseExercise:
    ''' Base class to represent an exercise within an exam'''
    def __init__(self, *, question):
        self.question = question
        self.x_data   = None

    def row_number(self):
        """Number of rows retrieved after execute this exerise"""
        if not self.x_data:
            return 0  # Actually unknown

        return len(self.x_data)

    def col_number(self):
        """Number of columns retrieved after execute this exerise"""
        if not self.x_data:
            return 0  # Actually unknown
        elif len(self.x_data) == 0:
            return 0  # Actually unknown
        else:
            return len(self.x_data[0])
