#!/usr/bin/env python3
__author__ = 'David Escribano Garcia'
__license__ = 'EUPL v.1.2'

import cmd
import glob as gb
import logging as log
import os
import sys

from sqlgh.config import Config
from sqlgh.project import Project

try:
    import readline
except ImportError:
    import pyreadline as readline


class SqlGh(cmd.Cmd):
    intro  = ('*** Welcome to the sql-gh *** \n'
              'Type help to list commands.\n'
              'Type ctrl-d to quit.\n')
    prompt = 'sql-gh> '
    sqlgh  = Config()

    def do_add(self, args):
        (name, db, schema, solved) = args.split(" ")
        if name in self.sqlgh.projects:
            print("Cannot add project '{}': name already in use".format(name))
            return

        if db not in self.sqlgh.databases:
            print("Cannot add project '{}': '{}' database connection not found"
                  .format(name, db))
            return

        project = Project.create(name=name,
                                 database=db,
                                 schema_file=schema,
                                 solved_file=solved)

        print("Template exam generated in {}".format(project.template_file))
        print("Please provide this template to students.")
        print(("Once they have finished, copy all the <student_name.sql> "
               "files to {} and execute `hint {}` command to get "
               "partial grades").format(project.original_exams_dir, name))

    def help_add(self):
        print('Add a new exam project')
        print()
        print('Usage:')
        print('  add NAME DATABASE SCHEMA SOLVED')
        print()
        print('Parameters:')
        print('  NAME     : Name of your project')
        print('  DATABASE : Database server you will connect to. Run `db list` to list available databases')
        print('  SCHEMA   : Path to SQL file containing DDL and DML statements to create the database')
        print('  SOLVED   : Path to SQL file containing the exam including answers')
        print()

    def complete_add(self, text, line, begidx, endidx):
        args = line.split(" ")
        if (len(args) <= 2):
            options = []
        elif (len(args) == 3):
            options = self.sqlgh.databases
        else:
            if os.path.isdir(text):
                options = gb.glob(os.path.join(text, '*'))
            else:
                options = gb.glob(text + '*')

        return [o for o in options if (o.startswith(text))]

    def do_hint(self, name):
        project = Project.recover(name)
        if (len(project.student_exams) == 0):
            print("No student exams found. Please copy them to '{}'."
                  .format(project.original_exams_dir, name))
            return
        project.generate_mark_hints()
        print('Hints generated correctly in file {}.'.format(project.hinted_file))
        print('Edit this file and assign marks to all exercises.')
        print('Once you are done execute `mark {}`'.format(name))
        print()

    def help_hint(self):
        print('Automatically generate hints to correct an exam')
        print()
        print('Usage:')
        print('  hint NAME')
        print()
        print('Parameters:')
        print('  NAME     : Name of the exam project you want to generate hints for')
        print()

    def complete_hint(self, text, line, begidx, endidx):
        options  = self.sqlgh.projects
        return [o for o in options if (o.startswith(text))]

    def do_list(self, args):
        print("-" * 80)
        print("{:25} | {:40}".format('project', 'dir'))
        print("-" * 80)
        for name in self.sqlgh.projects:
            if args.upper() in name.upper():
                p = Project(name)
                print("{:25} | {:40}"
                      .format(p.name, p.base_dir))

        print("-" * 80)
        print()

    def help_list(self):
        print('List available exam projects')
        print('')
        print('Usage:')
        print('  list [pattern]')

    def do_magic_autoscore(self, name):
        project = Project.recover(name)
        if (len(project.student_exams) == 0):
            print("No student exams found. Please copy them to '{}'."
                  .format(project.original_exams_dir, name))
            return
        project.generate_mark_hints(autoscore=True)
        project.parse_marks()

    def help_magic_autoscore(self):
        print('Generate marks automagically')
        print('NOTICE this is not recommended. You should normally use')
        print('`hint NAME` and `mark NAME` to do a manual marking')
        print()
        print('Usage:')
        print('  magic_autoscore NAME')
        print()
        print('Parameters:')
        print('  NAME     : Name of the exam project you want to generate marks for')
        print()

    def complete_magic_autoscore(self, text, line, begidx, endidx):
        options  = self.sqlgh.projects
        return [o for o in options if (o.startswith(text))]

    def do_mark(self, name):
        try:
            project = Project.recover(name)
            project.parse_marks()
            print('Parsed marks.')
            print('All marked exams located in {}.'.format(project.marked_exams_dir))
        except Exception as e:
            print("Could not parse marks: {}".format(e))

        print('')

    def help_mark(self):
        print('Parse marks and translate them to student exam files')
        print()
        print('Usage:')
        print('  mark NAME')
        print()
        print('Parameters:')
        print('  NAME     : Name of the exam project you want to parse marks for')
        print()

    def complete_mark(self, text, line, begidx, endidx):
        options  = self.sqlgh.projects
        return [o for o in options if (o.startswith(text))]

    def do_db(self, arg):
        arg = arg.strip()
        if (arg == 'list'):
            print("-" * 80)
            print("{:30} | {:10} | {:30}".format('name', 'rdbms', 'host'))
            print("-" * 80)
            for name in self.sqlgh.databases:
                info = self.sqlgh.database(name)
                print("{:30} | {:10} | {}:{}"
                      .format(name, info['rdbms'], info['host'], info['port']))
            print("-" * 80)
            print()

        elif (arg.startswith('add')):
            (command, rdbms, name, hostport, *user_password) = arg.split()
            (host, port) = hostport.split(':') if ':' in hostport else (hostport, None)
            user = user_password[0] if user_password else ''
            password = user_password[1] if len(user_password) > 1 else ''

            self.sqlgh.add_database(name=name, host=host
                                    , port=port, rdbms=rdbms
                                    , user=user, password=password)

        elif (arg.startswith('remove')):
            (command, db) = arg.split()
            self.sqlgh.remove_database(db)

        elif (arg.startswith('available_rdbms')):
            [print(rdbms) for rdbms in self.sqlgh.supported_databases]

    def help_db(self):
        print('Manage database connections within the application')
        print('')
        print('Usage:')
        print('  db list                                    - List database connections')
        print('  db add RDBMS NAME HOST[:PORT] [USER PASS]  - Add database connection')
        print('  db remove NAME                             - Remove database connection')
        print('  db available_rdbms                         - List available RDBMS')
        print()

    def complete_db(self, text, line, begidx, endidx):
        options = []

        if line.startswith('db list') and line.count(' ') == 2:
            options = []
        elif line.startswith('db add') and line.count(' ') == 2:
            options = self.sqlgh.supported_databases
        elif line.startswith('db remove') and line.count(' ') == 2:
            options = self.sqlgh.databases
        elif line.count(' ') == 1:
            options = ['add', 'available_rdbms', 'list', 'remove']

        return [o for o in options if (o.startswith(text))]

    def do_quit(self, arg):
        sys.exit()

    def do_EOF(self, arg):
        return True


def main():
    readline.set_completer_delims(' \t\n')
    log.basicConfig(format='[%(asctime)s] [%(levelname)s]: %(message)s', level=log.DEBUG)
    SqlGh().cmdloop()


if __name__ == "__main__":
    main()
