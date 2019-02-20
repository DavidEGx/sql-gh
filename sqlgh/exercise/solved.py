__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

from sqlgh.exercise.base import BaseExercise


class SolvedExercise(BaseExercise):
    '''
    Represents a exercise solved by a teacher. Therefore,
    it contains all the information needed to mark
    an StudentExercise.

    Args:
        question (str): Problem as presented to the student.
        solution (str): SQL code that solves the question.
        score (float): Max score this exercise can be awarded.
        test (str): SELECT query needed to test an StudentExercise is
            correct. Required only if the exercise requires the use
            of DML or DDL. If `question` is answered using only DQL
            (aka SELECT) then `solution` works as `test`.

    Example (no test needed):
        SolvedExercise(
            question='Get the max salary from the table employee)',
            solution='SELECT max(salary) FROM employee;'
        )

    Example (test required):
        SolvedExercise(
            question="Add a new employee named 'David'",
            answer="INSERT INTO employee (name) VALUES ('David');",
            test="SELECT count(*) FROM employee WHERE name = 'David';"
        )
    '''
    def __init__(self, *, question, solution, score=1, test=None,
                 include=None, exclude=None):
        BaseExercise.__init__(self, question=question)
        self.solution = solution
        self.score    = score
        self.test     = test
        self.include  = include
        self.exclude  = exclude
