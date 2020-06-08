//
//  SongViewController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/6/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class SongViewController: UIViewController {
    // MARK: - Variables

    var jiggler = UIImpactFeedbackGenerator(style: .heavy)
    var musicPlayer: MusicPlayer?
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    var currentSong: Song? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backButton: DefaultButton!
    @IBOutlet private weak var listButton: DefaultButton!
    @IBOutlet private weak var nowPlayingLabel: UILabel!
    @IBOutlet private weak var artworkImageView: DefaultImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var explicitImage: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var timeSlider: DefaultSlider!
    @IBOutlet private weak var skipBackButton: DefaultButton!
    @IBOutlet private weak var skipForwardButton: DefaultButton!
    @IBOutlet private weak var pausePlayButton: DefaultButton!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        timeSlider.isContinuous = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentSong = musicPlayer?.song
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        currentSong = musicPlayer?.song
        
        NotificationCenter.default.addObserver(self, selector: #selector(songUpdated), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerStatusUpdated), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        
        playerStatusUpdated()
        
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.isMultipleTouchEnabled = true
        artworkImageView.jiggler = jiggler
        
        updateGradient()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.delegate = self
        timeSlider.minimumValue = 0
        
        explicitImage.tintColor = .buttonColor
        
        setupButtons()
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = self.view.bounds
    }
    
    private func updateViews() {
        guard isViewLoaded else { return }
        
        updateGradient()
        if let song = currentSong {
            artworkImageView.setImage(song.artwork)
            totalTimeLabel.text = song.duration.stringTime
            artistNameLabel.text = song.artist
            songNameLabel.text = song.title
            timeSlider.maximumValue = Float(song.duration)
            updateTime()
            explicitImage.isHidden = !song.isExplicit
        } else if let song = musicPlayer?.song {
            currentSong = song
        } else {
            artworkImageView.setImage(UIImage(named: "Placeholder"))
            explicitImage.isHidden = true
            totalTimeLabel.text = "0:00"
            artistNameLabel.text = ""
            songNameLabel.text = "No Song Selected"
            timeSlider.maximumValue = 0.01
            updateTime()
        }
    }
    
    private func updateTime() {
        guard let musicPlayer = musicPlayer else { return }
        currentTimeLabel.text = musicPlayer.currentTime.stringTime
        timeSlider.value = Float(musicPlayer.currentTime)
    }
    
    private func tap() {
        jiggler.impactOccurred()
    }
    
    private func setupButtons() {
        backButton.action = { [unowned self] in
            self.tap()
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        listButton.action = { [unowned self] in // TODO: - Add action
            self.tap()
        }
        
        skipBackButton.action = { [unowned self] in
            self.tap()
            self.musicPlayer?.skipBack()
        }
        
        skipForwardButton.action = { [unowned self] in
            self.tap()
            self.musicPlayer?.skipForward()
        }
        
        pausePlayButton.action = { [unowned self] in
            self.tap()
            guard let musicPlayer = self.musicPlayer else { return }
            musicPlayer.toggle()
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    func playerStatusUpdated() {
        guard isViewLoaded else { return }
        let isPlaying = musicPlayer?.isPlaying ?? false
        
        timeSlider.playerStatusUpdated(isPlaying: isPlaying)
        
        if isPlaying {
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            pausePlayButton.colors = [UIColor.playButtonLightColor.cgColor, UIColor.playButtonDarkColor.cgColor]
            nowPlayingLabel.text = "Playing Now"
        } else {
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            pausePlayButton.colors = [UIColor.pauseButtonLightColor.cgColor, UIColor.pauseButtonDarkColor.cgColor]
            nowPlayingLabel.text = "Paused"
        }
    }
    
    @objc
    func songUpdated() {
        currentSong = musicPlayer?.song
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateGradient()
    }
}

// MARK: - Extensions

extension SongViewController: DefaultSliderDelegate {
    func timerFired() {
        updateTime()
    }
    
    func sliderChanged(_ sender: UISlider) {
        guard let time = TimeInterval(exactly: sender.value) else { return }
        musicPlayer?.set(time: time)
//        updateTime()
    }
}
