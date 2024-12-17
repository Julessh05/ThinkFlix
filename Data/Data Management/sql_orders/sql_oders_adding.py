import sqlite3

class SQLOrdersAdding:

    @staticmethod
    def questions(cursor, question_data):
        for question in question_data:
            cursor.execute("""
            INSERT OR REPLACE INTO question (id, question, answer, difficulty, category_id)
            VALUES (?, ?, ?, ?, ?)
            """, (
                question['id'],
                question['question'],
                question['answer'],
                question['difficulty'],
                question['category_id']
                )
            )

    @staticmethod
    def categories(cursor, category_data):
        for category in category_data:
            cursor.execute("""
            INSERT OR REPLACE INTO category (id, name, master_category_id)
            VALUES (?, ?, ?)
            """, (
                category['id'],
                category['name'],
                category['master_category_id']
                )
            )

    @staticmethod
    def management(cursor, version):
        cursor.execute("""
        INSERT OR REPLACE INTO management (id, version)
        VALUES (1, ?)
        """, version)