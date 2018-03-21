//
//  SetupViewController.swift
//  RoadChat
//
//  Created by Niklas Sauer on 18.03.18.
//  Copyright © 2018 Niklas Sauer. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController {
    
    // MARK: - Public Properties
    typealias Factory = ViewControllerFactory & AuthenticationManagerFactory
    
    // MARK: - Private Properties
    private var factory: Factory!
    private lazy var authenticationManager = factory.makeAuthenticationManager()
    
    // MARK: - Initialization
    class func instantiate(factory: Factory) -> SetupViewController {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        controller.factory = factory
        return controller
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        try? authenticationManager.resetCredentials()
    
        authenticationManager.getAuthenticatedUser { user in
            guard let user = user else {
                // show login view
                let loginViewController = self.factory.makeLoginViewController()
                let loginNavigationController = UINavigationController(rootViewController: loginViewController)
                (UIApplication.shared.delegate! as! AppDelegate).show(loginNavigationController)
                return
            }
            
            // show home screen
            let homeTabBarController = self.factory.makeHomeTabBarController(for: user)
            (UIApplication.shared.delegate! as! AppDelegate).show(homeTabBarController)
        }
    }

}
