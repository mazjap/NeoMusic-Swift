//
//  NeoTabBarController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 8/6/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class NeoTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homevc = HomeViewController()
        homevc.tabBarItem.image = UIImage(systemName: "play.circle")
        
        setViewControllers([homevc], animated: true)
        
        let safeAreaInsets = view.safeAreaInsets
        
        let nowPlayingView = NowPlayingView(frame: CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: view.frame.width - safeAreaInsets.left - safeAreaInsets.right, height: view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom - tabBar.frame.height))
        homevc.nowPlayingView = nowPlayingView
        
        view.addSubview(nowPlayingView)
    }
}
