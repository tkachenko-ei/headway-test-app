//
//  BookPlayerCoordinator.swift
//  HeadwayTestApp
//
//  Created by Yevhenii on 22.12.2024.
//

import ComposableArchitecture
import SwiftUI
import Coordinator

import Foundation
import NonEmpty

final class BookPlayerCoordinator: ChildCoordinator {
    var navigationController: UINavigationController
    var viewController: UIViewController?
    weak var parentCoordinator: ParentCoordinator?
    
    init(
        with navigationController: UINavigationController,
        parent parentCoordinator: ParentCoordinator
    ) {
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }
    
    public func start(animated: Bool) {
        let image: NonEmptyString = "Ask and It Is Given"
        let audios: NonEmptyArray<String> = [
            "Ask and It Is Given 1",
            "Ask and It Is Given 2",
            "Ask and It Is Given 3",
            "Ask and It Is Given 4",
            "Ask and It Is Given 5",
            "Ask and It Is Given 6",
            "Ask and It Is Given 7"
        ]

        let state = BookPlayer.State(image: image, audios: audios.map { name in
            let path = Bundle.main.path(forResource: name, ofType: "mp3")!
            return URL(fileURLWithPath: path)
        })
        let store = Store(initialState: state) {
            BookPlayer()
        }
        let view = BookPlayerView(store: store)
        viewController = UIHostingController(rootView: view)
        
        guard let viewController else { return }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func didFinish() {
        parentCoordinator?.removeChildCoordinator(self)
    }
}
