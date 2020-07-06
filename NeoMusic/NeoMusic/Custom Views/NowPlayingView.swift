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
            
            prepareToPlay()
            playerStatusUpdated()
        }
    }
    
    var ibs = [UIView]()
    var settingsController: SettingsController?
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    var hasBeenSetup = false
    var isOpen = true
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
    @IBOutlet private weak var secondarySongNameLabel: UILabel!
    
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
            bool ? performOpenAction() : performCloseAction()
        } else {
            isOpen ? performCloseAction() : performOpenAction()
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
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragView)))
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
            self.toggle(false)
        }
        
        listButton.action = { [unowned self] in // TODO: - Add action
            self.tap()
            self.toggle(true)
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
    
    private func prepareToPlay(_ songCategory: SongCategory = .all) {
        musicPlayer?.setSongList(songCategory)
    }
    
    private func showHide() {
        backButton.isHidden = !isOpen
        listButton.isHidden = !isOpen
        nowPlayingLabel.isHidden = !isOpen
    }
    
    private func performOpenAction(_ currentLocation: CGFloat = 0) {
        isOpen = true
        
        let viewTransformation = CGAffineTransform(translationX: 0, y: currentLocation - frame.height / 2)
        let imageViewTransformation = CGAffineTransform.identity
        let titleLabelTransformation = CGAffineTransform.identity
        let pausePlayButtonTransformation = CGAffineTransform.identity
        let skipBackButtonTransformation = CGAffineTransform.identity
        let skipForwardButtonTransformation = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = viewTransformation
            self.artworkImageView.transform = imageViewTransformation
            self.songNameLabel.transform = titleLabelTransformation
            self.pausePlayButton.transform = pausePlayButtonTransformation
            self.skipBackButton.transform = skipBackButtonTransformation
            self.skipForwardButton.transform = skipForwardButtonTransformation
            self.secondarySongNameLabel.tintColor = .clear
        }) { _ in
            self.secondarySongNameLabel.isHidden = true
            self.showHide()
        }
    }
    
    private func performCloseAction(_ currentLocation: CGFloat = 0) {
        isOpen = false
        
        let viewTransformation = CGAffineTransform(translationX: 0, y: frame.height - frame.width * 0.175 - 40 - currentLocation)
        let imageViewTransformation = CGAffineTransform(scaleX: 80 / artworkImageView.bounds.width, y: 80 / artworkImageView.bounds.height).concatenating(CGAffineTransform(translationX: backButton.frame.center.x - artworkImageView.frame.center.x, y: backButton.frame.center.y - artworkImageView.frame.center.y))
        let titleLabelTransformation = CGAffineTransform(scaleX: 0.55, y: 0.55).concatenating(CGAffineTransform(translationX: backButton.frame.center.x - songNameLabel.frame.center.x, y: nowPlayingLabel.frame.center.y - backButton.frame.center.y))
        let pausePlayButtonTransformation = CGAffineTransform(scaleX: 0.4, y: 0.4).concatenating(CGAffineTransform(translationX: listButton.frame.center.x - 20 - pausePlayButton.frame.center.x, y: backButton.frame.center.y - skipBackButton.frame.center.y))
        let skipBackButtonTransformation = CGAffineTransform(scaleX: 0.45, y: 0.45).concatenating(CGAffineTransform(translationX: listButton.frame.center.x - 70 - skipBackButton.frame.center.x, y: backButton.frame.center.y - skipBackButton.frame.center.y))
        let skipForwardButtonTransformation = CGAffineTransform(scaleX: 0.45, y: 0.45).concatenating(CGAffineTransform(translationX: listButton.frame.center.x + 30 - skipForwardButton.frame.center.x, y: backButton.frame.center.y - skipForwardButton.frame.center.y))
        
        secondarySongNameLabel.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = viewTransformation
            self.artworkImageView.transform = imageViewTransformation
            self.songNameLabel.transform = titleLabelTransformation
            self.pausePlayButton.transform = pausePlayButtonTransformation
            self.skipBackButton.transform = skipBackButtonTransformation
            self.skipForwardButton.transform = skipForwardButtonTransformation
            self.secondarySongNameLabel.tintColor = .white
        }) { _ in
            self.showHide()
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
    
    @objc
    func dragView(_ sender: UIPanGestureRecognizer) {
        guard let superview = superview else { return }
        
        let translation = sender.translation(in: self)
        let locationY = sender.location(in: superview).y
        let offset = self.center.y - superview.center.y
        
        if sender.state == .began || sender.state == .changed {
            if isOpen {
                if locationY <= 2 * superview.frame.height / 3{
                    performCloseAction(offset)
                    sender.isEnabled = false
                }
            } else {
                if locationY > superview.frame.maxY - 100 {
                    performOpenAction(offset)
                    sender.isEnabled = false
                }
            }
            
            if frame.minY + translation.y < superview.frame.maxY - 100 {
                center = CGPoint(x: center.x, y: center.y + translation.y)
                sender.setTranslation(CGPoint.zero, in: self)
            }
        } else if sender.state == .ended {
            if sender.isEnabled {
                if isOpen {
                    center = CGPoint(x: center.x, y: superview.center.y)
                } else {
                    center = CGPoint(x: center.x, y: frame.height - frame.width * 0.175 - 40)
                }
            } else if sender.location(in: superview).y >= superview.frame.height / 2 {
                performOpenAction(offset)
            }
            sender.isEnabled = true
        }
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
