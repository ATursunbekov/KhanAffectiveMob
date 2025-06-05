//
//  MainIterator.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

import UIKit
import CoreData

protocol MainInteratorProtocol {
    func fetchTodos()
    func getTodos() -> [TodoModel]
    func addTodo(_ todo: TodoModel)
    func updateData(data: [TodoModel])
    func saveToCoreData(_ todos: [TodoModel])
    var tasks: [TodoModel] {get set}
    var presenter: MainPresenter? {get set}
}

class MainInteractor: MainInteratorProtocol {
    weak var presenter: MainPresenter?

    var tasks: [TodoModel] = []
    private let fetchKey = "hasFetchedTodosOnce"

    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    func fetchTodos() {
        let hasFetched = UserDefaults.standard.bool(forKey: fetchKey)

        if hasFetched {
            loadFromCoreData()
            return
        }

        guard let url = URL(string: "https://dummyjson.com/todos") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                self.tasks = decoded.todos.map { TodoModel(from: $0) }

                DispatchQueue.main.async {
                    self.saveToCoreData(self.tasks)
                    UserDefaults.standard.set(true, forKey: self.fetchKey)
                    self.presenter?.reloadData(fetchedData: self.tasks)
                }
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
    }

    func getTodos() -> [TodoModel] {
        return tasks
    }

    func addTodo(_ todo: TodoModel) {
        tasks.append(todo)
        saveToCoreData(tasks)
    }

    func saveOnExit() {
        saveToCoreData(tasks)
    }
    
    func updateData(data: [TodoModel]) {
        tasks = data
    }

    func saveToCoreData(_ todos: [TodoModel]) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try? context.execute(deleteRequest)

        for todo in todos {
            let entity = TodoEntity(context: context)
            entity.title = todo.title
            entity.todo = todo.todo
            entity.date = todo.date
            entity.completed = todo.completed
        }

        do {
            try context.save()
        } catch {
            print("Core Data save error:", error)
        }
    }

    private func loadFromCoreData() {
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            self.tasks = entities.map {
                TodoModel(title: $0.title ?? "",
                          todo: $0.todo ?? "",
                          date: $0.date ?? "",
                          completed: $0.completed)
            }
            self.presenter?.reloadData(fetchedData: self.tasks)
        } catch {
            print("Core Data load error:", error)
        }
    }
}
