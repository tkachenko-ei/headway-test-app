//
//  ParentCoordinator.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

public protocol ParentCoordinator: Coordinator {
    var childCoordinators: [Coordinator] { get set }
    
    func addChildCoordinator(_ child: Coordinator?)
    func removeChildCoordinator(_ child: Coordinator?)
}

extension ParentCoordinator {
    public func addChildCoordinator(_ child: Coordinator?) {
        guard let child else { return }
        childCoordinators.append(child)
    }

    public func removeChildCoordinator(_ child: Coordinator?) {
        childCoordinators.removeAll { $0 === child }
    }
}
