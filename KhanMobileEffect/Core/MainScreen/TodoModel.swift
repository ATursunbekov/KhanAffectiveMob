//
//  TodoModel.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 1/6/25.
//

struct TodoModel {
    var title: String?
    var todo: String
    var date: String?
    var completed: Bool = false
    
    init(title: String, todo: String) {
        self.title = title
        self.todo = todo
        self.date = convertCurrentDateToString()
    }
    
    init(from dto: TodoDTO) {
        self.title = nil
        self.todo = dto.todo
        self.date = convertCurrentDateToString()
        self.completed = dto.completed
    }
}

struct TodoDTO: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

struct TodosResponse: Decodable {
    let todos: [TodoDTO]
}
