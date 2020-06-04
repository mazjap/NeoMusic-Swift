//
//  HomeViewController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/2/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var musicPlayer = MusicPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "ShowSongVCSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSongVCSegue", let destVC = segue.destination as? SongViewController {
            destVC.musicPlayer = musicPlayer
        }
    }
}
