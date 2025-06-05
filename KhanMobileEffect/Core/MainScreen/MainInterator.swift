//
//  MainIterator.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

import UIKit



class MainInteractor: MainInteractorProtocol {
    weak var output: MainInteractorOutput?
    private var tasks: [TodoModel] = []
    private let fetchKey = "hasFetchedTodosOnce"

    func fetchTodos() {
        let hasFetched = UserDefaults.standard.bool(forKey: fetchKey)
        guard !hasFetched else {
            output?.didFetchTodos(tasks)
            return
        }

        guard let url = URL(string: "https://dummyjson.com/todos") else {
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                self.tasks = decoded.todos.map { TodoModel(from: $0) }
                UserDefaults.standard.set(true, forKey: self.fetchKey)
                DispatchQueue.main.async {
                    self.output?.didFetchTodos(self.tasks)
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
    }
}


