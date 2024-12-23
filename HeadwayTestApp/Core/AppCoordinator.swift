//
//  AppCoordinator.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 22.12.2024.
//

import UIKit
import Coordinator

class AppCoordinator: ParentCoordinator {
    var navigationController = UINavigationController()
    var childCoordinators = [Coordinator]()
    
    func start(animated: Bool = false) {
        let coordinator = BookPlayerCoordinator(with: navigationController, parent: self)
        addChildCoordinator(coordinator)
        coordinator.start(animated: animated)
    }
}
