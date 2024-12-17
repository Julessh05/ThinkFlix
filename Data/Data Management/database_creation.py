import sqlite3

from json_input_reading import JSONInput
# Script to create the initial database and add all data to it


from sql_orders.sql_oders_adding import SQLOrdersAdding
from sql_orders.sql_oders_creation import SQLOrdersCreation

db_connection = sqlite3.connect('export/questions.sqlite')
cursor = db_connection.cursor()

# Create the management table
cursor.execute(SQLOrdersCreation.management_table())
# Add version to table
SQLOrdersAdding.management(cursor, JSONInput.read_management_file()["version"])


# Create the category table
cursor.execute(SQLOrdersCreation.category_table())
# Adding data to the category table
SQLOrdersAdding.categories(cursor, JSONInput.read_category_file())


# Create the question table
cursor.execute(SQLOrdersCreation.question_table())
# Adding data to the question table
SQLOrdersAdding.questions(cursor, JSONInput.read_questions_file())
