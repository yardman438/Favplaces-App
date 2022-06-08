//
//  SceneDelegate.swift
//  favplaces
//
//  Created by Serhii Dvornyk on 08.06.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let repository = Repository()
        
        let mainScreenModel = MainScreenModel(repository: repository)
        let mainScreenViewModel = MainScreenViewModel(model: mainScreenModel)
        let mainScreenViewController = MainScreenViewController(viewModel: mainScreenViewModel)
        
        let navigationControl = UINavigationController(rootViewController: mainScreenViewController)
                
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationControl
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
}
