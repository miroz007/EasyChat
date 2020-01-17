//
//  Reload.swift
//  EasyChat
//
//  Created by Amir on 1/16/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import Foundation
import  UIKit
import Firebase

extension AppDelegate {
    
    func isLoggedIn() -> Bool {
        if (Auth.auth().currentUser == nil ) {
            return true
        }
        else {
            return false
        }
    }
    
    func goToHomeVC() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //LOGIN
        let VC = storyboard.instantiateViewController(withIdentifier :"LoginVC")
        //HOME
        let VC1 = storyboard.instantiateViewController(withIdentifier :"NavBar")
        
        let navController = UINavigationController.init(rootViewController: isLoggedIn() ? VC : VC1)
        
        //        navController.isNavigationBarHidden = true
        
        ad.window?.rootViewController = navController
        ad.window?.makeKeyAndVisible()
        
    }
}
