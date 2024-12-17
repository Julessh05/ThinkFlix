
class SQLOrdersCreation:
    @staticmethod
    def question_table():
        return """
                CREATE TABLE IF NOT EXISTS question (
                questions TEXT
                answer TEXT
                answered BIT
                difficulty INTEGER
                )
                """

    @staticmethod
    def category_table():
        return """
        CREATE TABLE IF NOT EXISTS category ()
        """