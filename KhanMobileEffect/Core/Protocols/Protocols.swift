//
//  Protocols.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//

protocol MainViewProtocol: AnyObject {
    func showTodos(_ todos: [TodoModel])
}

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoad()
    func numberOfTasks() -> Int
    func task(at index: Int) -> TodoModel
    func didSearch(query: String)
    func didSelectTask(at index: Int)
}

protocol MainInteractorProtocol: AnyObject {
    func fetchTodos()
    func getTodos() -> [TodoModel]
    func addTodo(_ todo: TodoModel)
    var output: MainInteractorOutput? { get set }
}

protocol MainInteractorOutput: AnyObject {
    func didFetchTodos(_ todos: [TodoModel])
}

protocol MainRouterProtocol: AnyObject {
    func navigateToEdit(todo: TodoModel)
}
