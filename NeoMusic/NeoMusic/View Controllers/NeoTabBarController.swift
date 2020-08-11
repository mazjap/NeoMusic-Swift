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
        
        let nowPlayingView = NowPlayingView(frame: view.bounds)
        
        let homevc = HomeViewController(npv: nowPlayingView)
        homevc.tabBarItem.image = UIImage(systemName: "play.circle")
        
        setViewControllers([homevc], animated: true)
        
        view.addSubview(nowPlayingView)
    }
}
