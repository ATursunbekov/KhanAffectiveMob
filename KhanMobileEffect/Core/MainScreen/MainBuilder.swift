//
//  MainBuilder.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//

import UIKit

class MainModuleBuilder {
    static func build() -> UIViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let router = MainRouter()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
