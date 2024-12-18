class SQLOrdersCreation:
    @staticmethod
    def question_table():
        return """
                CREATE TABLE IF NOT EXISTS question (
                id INTEGER PRIMARY KEY,
                questions TEXT NOT NULL,
                answer TEXT NOT NULL,
                answered BIT,
                difficulty INTEGER,
                category_id INTEGER
                )
                """

    @staticmethod
    def category_table():
        return """
        CREATE TABLE IF NOT EXISTS category (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        master_category_id INTEGER
        )
        """

    @staticmethod
    def management_table():
        return """
        CREATE TABLE IF NOT EXISTS management (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        version INTEGER NOT NULL
        )
        """
