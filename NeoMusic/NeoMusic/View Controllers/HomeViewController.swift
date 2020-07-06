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
    var list = [SongCategory]()
    var musicPlayer: AppleMusicPlayer?
    var settingsController = SettingsController.shared
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    var nowPlayingView: NowPlayingView = .fromNib()
    
    let SpotifyClientID = "e5e6a8a7bca44bc1a12a5d0fa9af1235"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    @IBOutlet weak private var songSectionStackView: UIStackView!
    @IBOutlet weak private var stackViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var musicServiceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        musicServiceCollectionView.delegate = self
        musicServiceCollectionView.dataSource = self
        
        musicServiceCollectionView.register(UINib(nibName: "DefaultServiceCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MusicServiceCell")
        
        if settingsController.status(of: .appleMusic) {
            self.musicPlayer = AppleMusicPlayer()
            nowPlayingView.musicPlayer = musicPlayer
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
        let guide = view.layoutMarginsGuide
        view.addSubview(nowPlayingView)
        nowPlayingView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nowPlayingView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nowPlayingView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        nowPlayingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = self.view.bounds
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        nowPlayingView.musicPlayer = musicPlayer
        nowPlayingView.settingsController = settingsController
    }
    
    private func connectSpotify() {
//        nowPlayingView.toggle()
    }
    
    private func connectAppleMusic() {
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

// MARK: - Extension: UICollectionView Delegate & DataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getSections().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicServiceCell", for: indexPath) as? DefaultServiceCollectionViewCell else { return UICollectionViewCell() }
        let type = getSections()[indexPath.row]
        cell.type = type
        cell.setup()
        
        cell.delegate = self
        
        return cell
    }
    
    private func getSections() -> [SongType] {
        let types = SongType.allCases
        
        var cases = [SongType]()
        
        for type in types {
            if !settingsController.status(of: type) {
                cases.append(type)
            }
        }
        
        return cases
    }
}

// MARK: - Extension: SongOptionDelegate

extension HomeViewController: SongOptionDelegate {
    func buttonWasTapped(type: SongCategory) {
        nowPlayingView.isOpen = true
        musicPlayer?.setSongList(type)
    }
}

extension HomeViewController: DefaultServiceCollectionViewCellDelegate {
    func serviceConnected(type: SongType) {
        switch type {
        case .appleMusic:
            connectAppleMusic()
        case .spotify:
            connectSpotify()
        @unknown default:
            let alert = UIAlertController(title: "An Error Occurred", message: "The button you clicked isn't active. Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
}
