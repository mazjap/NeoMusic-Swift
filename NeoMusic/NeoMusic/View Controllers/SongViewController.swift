//
//  SongViewController.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/6/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit
import MediaPlayer

class SongViewController: UIViewController {
    // MARK: - Variables
    var jiggler = UINotificationFeedbackGenerator()
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
        gradientLayer.frame = self.view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.minimumValue = 0
    }
    
    private func updateViews() {
        if let song = currentSong, let musicPlayer = musicPlayer {
            artworkImageView.image = song.artwork
            totalTimeLabel.text = song.duration.stringTime
            artistNameLabel.text = song.artist
            songNameLabel.text = song.title
            timeSlider.maximumValue = Float(song.duration)
            currentTimeLabel.text = musicPlayer.currentTime.stringTime
        } else {
            
        }
    }
    
    private func updateTime() {
        guard let musicPlayer = musicPlayer else { return }
        currentTimeLabel.text = musicPlayer.currentTime.stringTime
        timeSlider.value = Float(musicPlayer.currentTime)
    }
    
    private func tap() {
        jiggler.notificationOccurred(.success)
    }
    
    @objc
    private func timerFired() {
        updateTime()
    }
    
    // MARK: - IBActions
    
    @IBAction func playPause(_ sender: UIButton) {
        tap()
        guard let musicPlayer = musicPlayer else { return }
        musicPlayer.toggle()
        
        if musicPlayer.isPlaying {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @IBAction func skipBack(_ sender: UIButton) {
        tap()
        musicPlayer?.skipBack()
    }
    
    @IBAction func skipForward(_ sender: UIButton) {
        tap()
        musicPlayer?.skipForward()
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        guard let time = TimeInterval(exactly: sender.value) else { return }
        musicPlayer?.set(time: time)
        updateTime()
    }
}

// MARK: - Extensions

extension SongViewController: MusicPlayerDelegate {
    func playerStatusUpdated(isPlaying: Bool) {
        pausePlayButton.setImage(UIImage(systemName: isPlaying ? "pause.fill" : "play.fill"), for: .normal)
    }
    
    func songUpdated(song: Song) {
        currentSong = song
    }
    
    func currentTimeUpdated(time: String) {
        currentTimeLabel.text = time
    }
}
