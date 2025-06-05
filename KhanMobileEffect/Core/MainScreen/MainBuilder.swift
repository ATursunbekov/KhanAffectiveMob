//
//  MainBuilder.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//

import UIKit

class MainModuleBuilder {
    static var sharedInteractor: MainInteratorProtocol?
    
    static func build() -> UIViewController {
        let view = MainViewController()
        let interactor = MainInteractor()
        let router = MainRouter()
        let presenter = MainPresenter(view: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        sharedInteractor = interactor

        return view
    }
}
