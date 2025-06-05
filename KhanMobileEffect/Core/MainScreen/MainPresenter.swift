//
//  MainPresenter.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 4/6/25.
//

import UIKit

protocol MainPresenterProtocol {
    func viewDidLoad()
    func reloadData(fetchedData: [TodoModel])
    func navigateToEdit(vc: UIViewController)
    func presentView(vc: UIViewController)
    func update(data: [TodoModel])
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?
    var interactor: MainInteratorProtocol
    var router: MainRouterProtocol

    var allTodos: [TodoModel] = []
    var filteredTodos: [TodoModel] = []
    var isFiltering = false

    init(view: MainViewProtocol, interactor: MainInteratorProtocol, router: MainRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func reloadData(fetchedData: [TodoModel]) {
        view?.reloadData(data: fetchedData)
    }
    
    func navigateToEdit(vc: UIViewController) {
        router.navigateToEdit(vc: vc)
    }
    
    func presentView(vc: UIViewController) {
        router.presentView(view: vc)
    }
    
    func update(data: [TodoModel]) {
        interactor.updateData(data: data)
        interactor.saveToCoreData(data)
    }
}
