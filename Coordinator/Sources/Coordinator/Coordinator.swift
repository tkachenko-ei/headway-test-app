//
//  Coordinator.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import UIKit

public protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start(animated: Bool)
}

extension Coordinator {
    public func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    public func popViewController(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }

    public func popViewController(to viewController: UIViewController, animated: Bool) {
        navigationController.popToViewController(viewController, animated: animated)
    }
}
