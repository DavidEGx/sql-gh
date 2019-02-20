import setuptools

setuptools.setup(
    name='sqlgh',
    version='0.1',
    packages=setuptools.find_namespace_packages(),
    scripts=['sql-gh.py'],

    author='David Escribano Garcia',
    author_email='davidegx@gmail.com',
    url='https://github.com/DavidEGx/sql-gh',
    license='EUPL 1.2',
    keywords='sql grade mark grading marking exam test tool automatically helper',

    install_requires=[
        'mysql.connector',
        'psycopg2',
        'readline;platform_system!="Windows"',
        'pyreadline;platform_system=="Windows"',
        'mysql-connector-python;platform_system=="Windows"',
    ]
)
