import sqlite3

# Script to create the initial database and add all data to it


from sql_orders.sql_oders_adding import SQLOrdersAdding
from sql_orders.sql_oders_creation import SQLOrdersCreation

db_connection = sqlite3.connect('export/questions.sqlite')
cursor = db_connection.cursor()

# Create the category table
cursor.execute(SQLOrdersCreation.category_table())

# Adding data to the category table
cursor.execute(SQLOrdersAdding.categories())

# Create the question table
cursor.execute(SQLOrdersCreation.question_table())

# Adding data to the question table
cursor.execute(SQLOrdersAdding.questions())

