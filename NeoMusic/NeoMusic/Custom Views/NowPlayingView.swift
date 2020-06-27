//
//  NowPlayingView.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/17/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation

class NowPlayingView: UIView {
    
    // MARK: - Variables
    
    var jiggler = UIImpactFeedbackGenerator(style: .heavy)
    var musicPlayer: AppleMusicPlayer? {
        didSet {
            NotificationCenter.default.addObserver(self, selector: #selector(songUpdated), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playerStatusUpdated), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
            
            playerStatusUpdated()
        }
    }
    
    var settingsController: SettingsController?
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    var hasBeenSetup = false
    var isOpen = false
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
    @IBOutlet weak var secondarySongNameLabel: UILabel!
    
    var ibs = [UIView]()
    
    // MARK: - Class Functions
    
    class func fromNib() -> NowPlayingView {
        guard let nib = Bundle.main.loadNibNamed("NowPlayingView", owner: nil, options: nil)?.first,
              let view = nib as? NowPlayingView else { fatalError() }
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    // MARK: - Superclass Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setup()
    }
    
    override func awakeAfter(using coder: NSCoder) -> Any? {
        guard subviews.isEmpty else { return self }
        return Bundle.main.loadNibNamed("MainNavbar", owner: nil, options: nil)?.first
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupShadows()
    }
    
    // MARK: - Public Functions
    
    func toggle(_ bool: Bool? = nil) {
        if let bool = bool {
            bool ? openMenu() : closeMenu()
        } else {
            isOpen ? closeMenu() : openMenu()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        guard let _ = artworkImageView, let _ = totalTimeLabel, let _ = artistNameLabel, let _ = songNameLabel,
              let _ = timeSlider, let _ = explicitImage, !hasBeenSetup else { return }
        hasBeenSetup = true
        
        ibs = [backButton, listButton, nowPlayingLabel, artworkImageView, songNameLabel, explicitImage, artistNameLabel,
               currentTimeLabel, totalTimeLabel, timeSlider, skipBackButton, skipForwardButton, pausePlayButton]
        
        currentSong = musicPlayer?.song
        
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.isMultipleTouchEnabled = true
        artworkImageView.jiggler = jiggler
        
        updateGradient()
        layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.delegate = self
        timeSlider.minimumValue = 0
        
        explicitImage.tintColor = .buttonColor
        
        setupButtons()
    }
    
    private func setupShadows() {
        for view in ibs {
            if let deview = view as? DefaultView {
                insertSubview(deview.shadowView, at: 0)
                deview.setupShadows()
            }
        }
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
    }
    
    private func updateViews() {
        guard let _ = artworkImageView, let _ = totalTimeLabel, let _ = artistNameLabel, let _ = songNameLabel, let _ = timeSlider, let _ = explicitImage else { return }
        
        let song: Song
        if let currentSong = currentSong {
            song = currentSong
        } else {
            song = .noSong
        }
        
        artworkImageView.setImage(song.artwork)
        totalTimeLabel.text = song.duration.stringTime
        artistNameLabel.text = song.artist
        songNameLabel.text = song.title
        secondarySongNameLabel.text = song.title
        timeSlider.maximumValue = Float(song.duration)
        updateTime()
        explicitImage.isHidden = !song.isExplicit
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
            self.closeMenu()
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
    
    private func showHide() {
        DispatchQueue.main.async {
            self.backButton.backgroundColor = .clear
            self.backButton.tintColor = .clear
            self.backButton.buttonTintColor = .clear
            self.listButton.backgroundColor = .clear
            self.listButton.tintColor = .clear
            self.listButton.buttonTintColor = .clear
            self.nowPlayingLabel.tintColor = .clear
            
            self.backButton.isHidden = !self.isOpen
            self.listButton.isHidden = !self.isOpen
            self.nowPlayingLabel.isHidden = !self.isOpen
        }
    }
    
    private func openMenu(_ animated: Bool = true) {
        isOpen = true
        
        let action = {
            DispatchQueue.main.async { [unowned self] in
                self.transform = .identity
                self.artworkImageView.transform = .identity
                self.songNameLabel.transform = .identity
                self.pausePlayButton.button.transform = .identity
                self.skipBackButton.button.transform = .identity
                self.skipForwardButton.button.transform = .identity
                self.showHide()
                self.secondarySongNameLabel.tintColor = .clear
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: action) { _ in
                self.secondarySongNameLabel.isHidden = true
            }
        } else {
            action()
            self.secondarySongNameLabel.isHidden = true
        }
    }
    
    private func closeMenu(_ animated: Bool = true) {
        isOpen = false
        secondarySongNameLabel.isHidden = false
        
        let viewTransformation = CGAffineTransform(translationX: 0, y: frame.height - frame.width * 0.175 - 40)
        let imageViewTransformation = CGAffineTransform(translationX: backButton.frame.center.x - artworkImageView.frame.center.x, y: backButton.frame.center.y - artworkImageView.frame.center.y).scaledBy(x: 80 / artworkImageView.bounds.width, y: 80 / artworkImageView.bounds.height)
        let titleLabelTransformation = CGAffineTransform(translationX: backButton.frame.center.x - songNameLabel.frame.center.x, y: nowPlayingLabel.frame.center.y - backButton.frame.center.y).scaledBy(x: 0.55, y: 0.55)
        let pausePlayButtonTransformation = CGAffineTransform(translationX: listButton.frame.center.x - 20 - pausePlayButton.frame.center.x, y: backButton.frame.center.y - skipBackButton.frame.center.y).scaledBy(x: 0.4, y: 0.4)
        let skipBackButtonTransformation = CGAffineTransform(translationX: listButton.frame.center.x - 70 - skipBackButton.frame.center.x, y: backButton.frame.center.y - skipBackButton.frame.center.y).scaledBy(x: 0.45, y: 0.45)
        let skipForwardButtonTransformation = CGAffineTransform(translationX: listButton.frame.center.x + 30 - skipForwardButton.frame.center.x, y: backButton.frame.center.y - skipForwardButton.frame.center.y).scaledBy(x: 0.45, y: 0.45)
        
        let action = {
            DispatchQueue.main.async { [unowned self] in
                self.transform = viewTransformation
                self.artworkImageView.transform = imageViewTransformation
                self.songNameLabel.transform = titleLabelTransformation
                self.pausePlayButton.transform = pausePlayButtonTransformation
                self.skipBackButton.transform = skipBackButtonTransformation
                self.skipForwardButton.transform = skipForwardButtonTransformation
                self.showHide()
                self.secondarySongNameLabel.tintColor = .white
            }
        }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: action)
        } else {
            action()
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    private func playerStatusUpdated() {
        guard let timeSlider = timeSlider else { return }
        
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
        
        updateViews()
    }
    
    @objc
    private func songUpdated() {
        currentSong = musicPlayer?.song
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateGradient()
    }
}

// MARK: - Extensions

extension NowPlayingView: DefaultSliderDelegate {
    func timerFired() {
        if currentSong != nil {
            updateTime()
        }
    }
    
    func sliderChanged(_ sender: UISlider) {
        guard let time = TimeInterval(exactly: sender.value) else { return }
        musicPlayer?.set(time: time)
    }
}
