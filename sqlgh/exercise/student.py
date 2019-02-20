__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

from sqlgh.exercise.base import BaseExercise


class StudentExercise(BaseExercise):
    '''
    Exercise submitted by an student. It will be compared
    against a SolvedExercise to get a mark.

    Args:
        answer(str): Answer provided by an student.
    '''
    def __init__(self, *, question, answer):
        BaseExercise.__init__(self, question=question)
        self.answer   = answer
        self.score    = 0
        self.feedback = ''

        self.x_runs_ok      = False
        self.x_error        = ''
        self.x_identical    = False
        self.x_ignore_order = False
        self.x_row_number   = False
        self.x_col_number   = False
