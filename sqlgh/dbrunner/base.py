__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'


class DBRunnerBase():
    """
    Runs exercises in exams against some database. There should
    be a subclass for each supported RDBMS.
    """

    def __init__(self, project, *, rdbms, host, port, user, password):
        self.project  = project
        self.rdbms    = rdbms
        self.host     = host
        self.port     = port
        self.user     = user
        self.password = password

    def execute(self):
        """
        Execute the exercises. That will require:

        1. Create a database with the `schema` provided.

        2. For each exercise in the `solved` exam:
            1. Create a new database.
            2. Run the code.
            3. Store output in exercise.data
           Notice we need a new database since each exercise
           could potentially modify the data.

        3. For each student exam:
            1. For each exercise copy the `solved` database.
            2. Run the student code.
            3. Store output in exercise.data
           Notice we copy database from `solved` exam instead of
           reusing the database from the previous exercise. This is
           required since a student failing an exercise could leave
           the database in a wrong state.

        This method needs to be overwritten in each supported RDBMS.

        """
        raise NotImplementedError('Implement in subclasses')
