import json

class JSONInput:

    @staticmethod
    def read_questions_file():
        with open("data/questions.json", 'r') as json_file:
            return json.load(json_file)

    @staticmethod
    def read_category_file():
        with open("data/categories.json", 'r') as json_file:
            return json.load(json_file)

    @staticmethod
    def read_management_file():
        with open("data/management.json", 'r') as json_file:
            return json.load(json_file)