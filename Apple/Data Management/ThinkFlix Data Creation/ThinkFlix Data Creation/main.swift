//
//  main.swift
//  ThinkFlix Data Creation
//
//  Created by Julian Schumacher on 19.12.24.
//

import Foundation
import CoreData

let categories : [CategoryJSON]
var questions : [QuestionJSON]
do {
    categories = try JSONInput.readCategories()
    questions = try JSONInput.readQuestions()
} catch {
    print("Error reading JSON: \(error)")
    abort()
}
let path = Bundle.main.url(forResource: "exportPath", withExtension: nil)
let exportPath = try String(data: Data(contentsOf: path!), encoding: .utf8)!
let jsonExportPath = URL(string: exportPath)
for i in 0..<questions.count {
    if questions[i].id == nil {
        questions[i].id = UUID()
    }
}
let jsonEncoder = JSONEncoder()
do {
    let data = try jsonEncoder.encode(questions)
    try data.write(to: URL(string: exportPath)!)
} catch {
    print("Error encoding questions to json \(error)")
    abort()
}

let context = PersistenceController.export.container.viewContext

for category in categories {
    let c = Category(context: context)
    c.name = category.name
    c.uuid = UUID()
    // TODO: work on
//    c.masterCategory = category.masterCategoryID
}
do {
    try context.save()
} catch {
    print("Error saving categories: \(error)")
    abort()
}

for question in questions {
    let q = Question(context: context)
    q.question = question.question
    q.answer = question.answer
    q.answered = false
    q.uuid = UUID()
}

do {
    try context.save()
} catch {
    print("Error saving questions: \(error)")
    abort()
}
