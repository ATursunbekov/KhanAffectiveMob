//
//  MainPresenter.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteractorProtocol
    var router: MainRouterProtocol

    private var allTodos: [TodoModel] = []
    private var filteredTodos: [TodoModel] = []
    private var isFiltering = false

    init(view: MainViewProtocol, interactor: MainInteractorProtocol, router: MainRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchTodos()
    }

    func numberOfTasks() -> Int {
        return isFiltering ? filteredTodos.count : allTodos.count
    }

    func task(at index: Int) -> TodoModel {
        return isFiltering ? filteredTodos[index] : allTodos[index]
    }

    func didSearch(query: String) {
        isFiltering = !query.isEmpty
        filteredTodos = allTodos.filter {
            $0.title.lowercased().contains(query.lowercased()) ||
            $0.todo.lowercased().contains(query.lowercased())
        }
        view?.showTodos(isFiltering ? filteredTodos : allTodos)
    }

    func didSelectTask(at index: Int) {
        let todo = task(at: index)
        router.navigateToEdit(todo: todo)
    }
}

extension MainPresenter: MainInteractorOutput {
    func didFetchTodos(_ todos: [TodoModel]) {
        self.allTodos = todos
        view?.showTodos(todos)
    }
}
