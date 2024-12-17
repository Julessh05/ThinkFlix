import json


class JSONInput:
    def __init__(self, file_name):
        self.file_name = file_name

    def read_file(self):
        with open(self.file_name) as json_file:
            return json.load(json_file)