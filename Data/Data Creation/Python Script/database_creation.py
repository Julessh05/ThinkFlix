import os
import sqlite3

from json_input_reading import JSONInput
from sql_orders.sql_oders_adding import SQLOrdersAdding
from sql_orders.sql_oders_creation import SQLOrdersCreation

# Script to create the initial database and add all data to it

FILE_PATH: str = 'export/quizContent.sqlite'

# Delete existing Database
if os.path.isfile(FILE_PATH):
    os.remove(FILE_PATH)

with sqlite3.connect(FILE_PATH) as connection:
    cursor = connection.cursor()

    # Create the management table
    cursor.execute(SQLOrdersCreation.management_table())
    # Add the current version to the table
    json = JSONInput.read_management_file()
    SQLOrdersAdding.management(cursor, JSONInput.read_management_file()["db_version"])
    connection.commit()

    # Create the category table
    cursor.execute(SQLOrdersCreation.category_table())
    # Add data to the category table
    SQLOrdersAdding.categories(cursor, JSONInput.read_category_file())
    connection.commit()

    # Create the question table
    cursor.execute(SQLOrdersCreation.question_table())
    # Add data to the question table
    SQLOrdersAdding.questions(cursor, JSONInput.read_questions_file())
    connection.commit()

    # Create the fact table
    cursor.execute(SQLOrdersCreation.fact_table())
    # Add data to the fact table
    SQLOrdersAdding.facts(cursor, JSONInput.read_facts_file())
    connection.commit()
