import uuid


class SQLOrdersAdding:

    @staticmethod
    def questions(cursor, question_data):
        for question in question_data:
            cursor.execute("""
            INSERT OR REPLACE INTO question (id, question, answer, difficulty, category_id)
            VALUES (?, ?, ?, ?, ?)
            """, (
                uuid.uuid4(),
                question['question'],
                question['answer'],
                question['difficulty'],
                question['category_id']
            ))

    @staticmethod
    def categories(cursor, category_data):
        for category in category_data:
            cursor.execute("""
            INSERT OR REPLACE INTO category (id, name, master_category_id)
            VALUES (?, ?, ?)
            """, (
                uuid.uuid4(),
                category['name'],
                category['master_category_id']
            ))

    @staticmethod
    def management(cursor, version):
        cursor.execute("""
        INSERT OR REPLACE INTO management (id, version)
        VALUES (?, ?)
        """, (1, version))

    @staticmethod
    def facts(cursor, fact_data):
        cursor.execute("""
            INSERT OR REPLACE INTO fact (id, true_fact, false_fact_1, false_fact_2, false_fact_3, master_category_id)
            VALUES (?, ?, ?, ?, ?, ?)
            """, (
            uuid.uuid4(),
            fact_data['true_fact'],
            fact_data['false_fact_1'],
            fact_data['false_fact_2'],
            fact_data['false_fact_3'],
            fact_data['master_category_id']
        ))
