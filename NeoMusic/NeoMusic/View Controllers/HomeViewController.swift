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
    var settingsController = SettingsController.shared
    let gradientLayer = CAGradientLayer()
    var colors: [CGColor] = [] {
        didSet {
            nowPlayingView.colors = colors
        }
    }
    var nowPlayingView: NowPlayingView!
    
    let SpotifyClientID = "e5e6a8a7bca44bc1a12a5d0fa9af1235"
    let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    private var titleLabel: UILabel!
    private var songSelectionStackView: UIStackView!
    private var stackViewHeightAnchor: NSLayoutConstraint!
    private var musicServiceCollectionView: UICollectionView!
    private var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        musicServiceCollectionView.delegate = self
        musicServiceCollectionView.dataSource = self
        
        musicServiceCollectionView.register(DefaultServiceCollectionViewCell.self, forCellWithReuseIdentifier: DefaultServiceCollectionViewCell.identifier)
        musicServiceCollectionView.register(CollectionViewHeaderFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionViewHeaderFooter.reuseIdentifier)
        musicServiceCollectionView.register(CollectionViewHeaderFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewHeaderFooter.reuseIdentifier)
        
        for service in SongType.allCases {
            if settingsController.status(of: service) {
                nowPlayingView.setupService(service)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
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
        let safeAreaInsets = view.safeAreaInsets
        
        let safeAreaFrame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: view.frame.width - safeAreaInsets.left - safeAreaInsets.right, height: view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom)
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: view.frame.width - 40, height: 50))
        songSelectionStackView = UIStackView(frame: CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: view.frame.width - 40, height: safeAreaFrame.height * 0.3))
        musicServiceCollectionView = UICollectionView(frame: CGRect(x: 0, y: songSelectionStackView.frame.maxY + 20, width: view.frame.width, height: 64), collectionViewLayout: UICollectionViewLayout())
        
        view.addSubview(titleLabel)
        view.addSubview(songSelectionStackView)
        view.addSubview(musicServiceCollectionView)
        
        setupSubviews()
        
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        updateGradient()
    }
    
    private func updateViews() {
        let gradient = settingsController.backgroundGradient
        
        colors = [gradient.0.cgColor, gradient.1.cgColor]
    }
    
    private func setupSubviews() {
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
//        songSelectionStackView.addArrangedSubview()
        
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = self.view.bounds
    }
    
    private func serviceConnected(type: SongType) {
        switch type {
        case .appleMusic:
            connectAppleMusic()
        case .spotify:
            connectSpotify()
        default:
            let alert = UIAlertController(title: "An Error Occurred", message: "The button you clicked isn't active. Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func connectSpotify() {
        
    }
    
    private func connectAppleMusic() {
        if SKCloudServiceController.authorizationStatus() == .notDetermined {
            SKCloudServiceController.requestAuthorization { status in
                switch status {
                case .denied, .restricted:
                    self.settingsController.setAppleMusicStatus(false)
                case .authorized:
                    self.settingsController.setAppleMusicStatus(true)
                    self.nowPlayingView.setupService(.appleMusic)
                default:
                    break
                }
            }
        } else if SKCloudServiceController.authorizationStatus() == .authorized {
            settingsController.setAppleMusicStatus(true)
            nowPlayingView.setupService(.appleMusic)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DefaultServiceCollectionViewCell.identifier, for: indexPath) as? DefaultServiceCollectionViewCell else { return UICollectionViewCell() }
        let type = getSections()[indexPath.row]
        cell.type = type
        cell.setup()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let type = (collectionView.cellForItem(at: indexPath) as? DefaultServiceCollectionViewCell)?.type else { return }
        serviceConnected(type: type)
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
        nowPlayingView.musicPlayer.setSongList(type)
    }
}
