//
//  MainIterator.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

import UIKit

protocol MainInteratorProtocol {
    func fetchTodos()
    func getTodos() -> [TodoModel]
    func addTodo(_ todo: TodoModel)
    var tasks: [TodoModel] {get set}
    var presenter: MainPresenter? {get set}
}

class MainInteractor: MainInteratorProtocol {
    var presenter: MainPresenter?
    
    private let fetchKey = "hasFetchedTodosOnce"
    var tasks: [TodoModel] = []
    
    func fetchTodos() {
        let hasFetched = UserDefaults.standard.bool(forKey: fetchKey)
        guard !hasFetched else { return }
        
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                self.tasks = decoded.todos.map { TodoModel(from: $0) }
                self.presenter?.reloadData(fetchedData: self.tasks)
                UserDefaults.standard.set(true, forKey: self.fetchKey)
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
    }
}
