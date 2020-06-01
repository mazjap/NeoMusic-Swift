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
    var timer: Timer?
    var musicPlayer: MusicPlayer? = MusicPlayer()
    var currentSong: Song? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var backButton: DefaultButton!
    @IBOutlet private weak var listButton: DefaultButton!
    @IBOutlet private weak var nowPlayingLabel: UILabel!
    @IBOutlet private weak var artworkImageView: SongImageView!
    @IBOutlet private weak var songNameLabel: UILabel!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var timeSlider: UISlider!
    @IBOutlet private weak var skipBackButton: DefaultButton!
    @IBOutlet private weak var skipForwardButton: DefaultButton!
    @IBOutlet private weak var pausePlayButton: DefaultButton!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicPlayer?.delegate = self
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.isMultipleTouchEnabled = true
        artworkImageView.jiggler = jiggler
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
        gradientLayer.frame = self.view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.minimumValue = 0
        
        setupButtons()
    }
    
    private func updateViews() {
        if let song = currentSong, let musicPlayer = musicPlayer {
            artworkImageView.setImage(song.artwork)
            totalTimeLabel.text = song.duration.stringTime
            artistNameLabel.text = song.artist
            songNameLabel.text = song.title
            timeSlider.maximumValue = Float(song.duration)
            currentTimeLabel.text = musicPlayer.currentTime.stringTime
        } else {
            // TODO: - Add no songs found state
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
        backButton.action = {} // TODO: - Add actions
        
        listButton.action = {} // "                 "
        
        skipBackButton.action = {
            self.tap()
            self.musicPlayer?.skipBack()
        }
        
        skipForwardButton.action = {
            self.tap()
            self.musicPlayer?.skipForward()
        }
        
        pausePlayButton.action = {
            self.tap()
            guard let musicPlayer = self.musicPlayer else { return }
            musicPlayer.toggle()
            
            if musicPlayer.isPlaying {
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
            } else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    private func timerFired() {
        updateTime()
    }
    
    // MARK: - IBActions
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        guard let time = TimeInterval(exactly: sender.value) else { return }
        musicPlayer?.set(time: time)
        updateTime()
    }
}

// MARK: - Extensions

extension SongViewController: MusicPlayerDelegate {
    func playerStatusUpdated(isPlaying: Bool) {
        if isPlaying {
            pausePlayButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            pausePlayButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    func songUpdated(song: Song) {
        currentSong = song
    }
    
    func currentTimeUpdated(time: String) {
        currentTimeLabel.text = time
    }
}
