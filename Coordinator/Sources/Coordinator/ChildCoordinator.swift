//
//  ChildCoordinator.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 18.12.2024.
//

import UIKit

public protocol ChildCoordinator: Coordinator {
    var viewController: UIViewController? { get set }
    
    func didFinish()
}
