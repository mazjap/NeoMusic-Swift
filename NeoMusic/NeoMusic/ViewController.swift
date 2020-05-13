//
//  ViewController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/6/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var skipBackButton: UIButton!
    @IBOutlet weak var skipForwardButton: UIButton!
    @IBOutlet weak var pausePlayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
    
    private func updateViews() {
        update(button: backButton)
        update(button: listButton)
        update(button: skipBackButton)
        update(button: skipForwardButton)
        update(button: pausePlayButton)
        
        
    }
    
    private func update(button: UIButton) {
        button.layer.cornerRadius = button.frame.height / 2
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black
    }
}

