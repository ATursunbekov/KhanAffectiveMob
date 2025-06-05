//
//  MainRouter.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//

import UIKit

protocol MainRouterProtocol {
    func navigateToEdit(vc: UIViewController)
    func presentView(view: UIViewController)
}

class MainRouter: MainRouterProtocol {
    weak var viewController: UIViewController?

    func navigateToEdit(vc: UIViewController) {
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func presentView(view: UIViewController) {
        viewController?.present(view, animated: false)
    }
}
