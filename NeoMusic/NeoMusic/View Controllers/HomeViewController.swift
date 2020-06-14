//
//  HomeViewController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/2/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import StoreKit

class HomeViewController: UIViewController {
    var list = [SongType]()
    var musicPlayer: AppleMusicPlayer?
    var settingsController = SettingsController.shared
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    
    let SpotifyClientID = "e5e6a8a7bca44bc1a12a5d0fa9af1235"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    @IBOutlet weak private var songSectionStackView: UIStackView!
    @IBOutlet weak private var stackViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak private var spotifyButton: MusicButton!
    @IBOutlet weak private var appleMusicButton: MusicButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        if settingsController.appleMusicStatus {
            self.musicPlayer = AppleMusicPlayer()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        guard let stackViewHeightAnchor = stackViewHeightAnchor else { return }
        
        stackViewHeightAnchor.constant = CGFloat(40 * list.count + 10)
        stackViewHeightAnchor.isActive = true
    }
    
    private func setup() {
        updateGradient()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        if settingsController.spotifyStatus {
            spotifyButton.isHidden = true
        } else {
            spotifyButton.color = .spotify
            spotifyButton.setImage(UIImage(named: "spotify_logo"), for: .normal)
            spotifyButton.setTitle("Connect Spotify", for: .normal)
        }
        
        if settingsController.appleMusicStatus {
            appleMusicButton.isHidden = true
        } else {
            appleMusicButton.color = .appleMusic
            appleMusicButton.setImage(UIImage(named: "apple_logo"), for: .normal)
            appleMusicButton.setTitle("Connect Apple Music", for: .normal)
        }
        
        setupSections()
    }
    
    private func setupSections() {
        songSectionStackView.translatesAutoresizingMaskIntoConstraints = false;
        songSectionStackView.spacing = 10
        
        var buttons = [SongOptionView]()
        for val in SongType.allCases {
            list.append(val)
            
            let button = SongOptionView()
            button.delegate = self
            songSectionStackView.addArrangedSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
//
            button.data = val
            buttons.append(button)
        }
        
        updateViewConstraints()
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = self.view.bounds
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSongVCSegue", let destVC = segue.destination as? SongViewController {
            destVC.musicPlayer = musicPlayer
            destVC.settingsController = settingsController
        }
    }
    
    @IBAction func connectSpotify(_ sender: MusicButton) {
        performSegue(withIdentifier: "ShowSongVCSegue", sender: self)
    }
    
    @IBAction func connectAppleMusic(_ sender: MusicButton) {
        if SKCloudServiceController.authorizationStatus() == .notDetermined {
            SKCloudServiceController.requestAuthorization { status in
                switch status {
                case .denied, .restricted:
                    self.settingsController.setAppleMusicStatus(false)
                case .authorized:
                    self.settingsController.setAppleMusicStatus(true)
                    self.musicPlayer = AppleMusicPlayer()
                default:
                    break
                }
            }
        } else if SKCloudServiceController.authorizationStatus() == .authorized {
            self.settingsController.setAppleMusicStatus(true)
            self.musicPlayer = AppleMusicPlayer()
        } else {
            let alert = UIAlertController(title: "User Action Required", message: "Unable to authorize Apple Music usage. Please open settings and allow access.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        if !success {
                            NSLog("Unable to open settings, please try again.")
                        }
                    })
                }
            }))
        }
    }
}

extension HomeViewController: SongOptionDelegate {
    func buttonWasTapped(type: SongType) {
        performSegue(withIdentifier: "ShowSongVCSegue", sender: self)
        musicPlayer?.setSongList(type)
    }
}
