//
//  AppCoordinator.swift
//  Runner
//
//  Created by XIANYANG LUO on 11/25/20.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }
    
    override func start() {
        super.start()
    }
    
    func downloadAndSetPassWithURL(url: String) {
        navigateToPassViewControllerWithURL(url: url)
    }
}

protocol PassToAppCoordinatorDelegate: class {
    func navigateToFlutterViewController()
}

protocol FlutterToAppCoordinatorDelegate: class {
    func navigateToPassViewControllerWithURL(url: String)
}

extension AppCoordinator: PassToAppCoordinatorDelegate {
    func navigateToFlutterViewController(){
        let coordinator = FlutterCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        self.add(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: FlutterToAppCoordinatorDelegate {
    func navigateToPassViewControllerWithURL(url: String){
        let coordinator = PassCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        self.add(coordinator)
        coordinator.start()
        coordinator.retrievePass(url: url)
    }
}
