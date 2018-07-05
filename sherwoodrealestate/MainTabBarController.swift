//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import SafariServices

class MainTabBarController: UITabBarController, UITabBarControllerDelegate, SFSafariViewControllerDelegate {
  
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
//        if index == 1 {
//            print("tap")
//            let urlString = "http://sherwoodrealestate.com/about-us"
//            let url = URL(string: urlString)
//            let searchNavController = SFSafariViewController(url: url!)
//            let navController = UINavigationController(rootViewController: searchNavController)
//
////            safariViewController.delegate = self
////            self.present(safariViewController, animated: true)
//
//           // let layout = UICollectionViewFlowLayout()
////            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
////            let navController = UINavigationController(rootViewController: photoSelectorController)
//            
//            present(navController, animated: true, completion: nil)
//            
//            return false
//        }
        
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

//        if Auth.auth().currentUser == nil {
//            //show if not logged in
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                let navController = UINavigationController(rootViewController: loginController)
//                self.present(navController, animated: true, completion: nil)
//            }
//            
//            return
//        }
        
        setupViewControllers()
    }
    
    func setupViewControllers() {
        //home
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        

//        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: WebViewController())

        

        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "grid"), selectedImage: #imageLiteral(resourceName: "grid"), rootViewController: AboutSherwoodVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "tennis"), selectedImage: #imageLiteral(resourceName: "tennis"), rootViewController: ClubsVC(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let userProfileController = AllListingsMapVC()
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "pins")
        userProfileNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "pins")
        
        
        let soldController = SoldMapAll()
        let soldNavController = UINavigationController(rootViewController: soldController)
        soldNavController.tabBarItem.image = #imageLiteral(resourceName: "sold_selected")
        soldNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "sold_selected")
//        let soldNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "sold_selected"), selectedImage: #imageLiteral(resourceName: "sold_selected"), rootViewController: SoldMapAll())
        
//            SoldMapAll()
//        print(soldNavController)
        
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController,
                           soldNavController]
        
        //modify tab bar item insets
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}






