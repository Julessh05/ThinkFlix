class SQLOrdersCreation:
    @staticmethod
    def question_table():
        return """
                CREATE TABLE IF NOT EXISTS question (
                id TEXT PRIMARY KEY,
                question TEXT NOT NULL,
                answer TEXT NOT NULL,
                answered BIT,
                difficulty INTEGER,
                category_id TEXT
                )
                """

    @staticmethod
    def category_table():
        return """
        CREATE TABLE IF NOT EXISTS category (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        master_category_id TEXT
        )
        """

    @staticmethod
    def fact_table():
        return """
        CREATE TABLE IF NOT EXISTS fact (
        id TEXT PRIMARY KEY,
        true_fact TEXT NOT NULL,
        false_fact_1 TEXT NOT NULL,
        false_fact_2 TEXT,
        false_fact_3 TEXT,
        master_category_id TEXT
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
