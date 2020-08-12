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
    
    private var jiggler = UIImpactFeedbackGenerator(style: .heavy)
    var musicPlayer: MusicPlayerController
    var settingsController = SettingsController.shared
    var colors: [CGColor] = [] {
        didSet {
            updateGradient()
        }
    }
    
    private var initialFrame: CGRect
    private var isOpen = true {
        didSet {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            animator.isReversed = !isOpen
        }
    }
    
    private var animator: UIViewPropertyAnimator!
    private var previousTranslation: CGFloat = 0
    
    private var currentSong: Song? {
        didSet {
            updateViews()
        }
    }
    
    private var backButton: DefaultButton!
    private var listButton: DefaultButton!
    private var nowPlayingLabel: DefaultLabel!
    private var artworkImageView: DefaultImageView!
    private var songNameLabel: DefaultLabel!
    private var explicitImage: UIImageView!
    private var artistNameLabel: DefaultLabel!
    private var timeStackView: UIStackView!
    private var timeLabelStackView: UIStackView!
    private var currentTimeLabel: DefaultLabel!
    private var totalTimeLabel: DefaultLabel!
    private var timeSlider: DefaultSlider!
    private var skipBackButton: DefaultButton!
    private var skipForwardButton: DefaultButton!
    private var pausePlayButton: DefaultButton!
    
    private let gradientLayer = CAGradientLayer()
    
    private var subs = [UIView]()
    private var btns = [DefaultButton]()
    
    
    // MARK: - Superclass Functions

    override init(frame: CGRect) {
        initialFrame = frame
        self.musicPlayer = MusicPlayerController()
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        initialFrame = CGRect()
        self.musicPlayer = MusicPlayerController()
        
        super.init(coder: coder)
        
        initialFrame = frame
        setup()
    }
    
    init(frame: CGRect, musicPlayer: MusicPlayerController) {
        initialFrame = frame
        self.musicPlayer = musicPlayer
        
        super.init(frame: frame)
        
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Public Functions
    
    func setupService(_ service: SongType) {
        musicPlayer.setupService(service)
        
        switch service {
        case .appleMusic:
            musicPlayer.appleMusicPlayer?.delegate = self
        case .spotify:
            musicPlayer.spotifyMusicPlayer?.delegate = self
        }
        
        songChanged(song: musicPlayer.song)
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        createSubviews()
        
        currentSong = musicPlayer.song
        
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: getCloseAnimation())
        
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.isMultipleTouchEnabled = true
        artworkImageView.jiggler = jiggler
        
        updateGradient()
        layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.delegate = self
        timeSlider.minimumValue = 0
        
        setupButtons()
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragView)))
        
        for btn in self.btns {
            btn.button.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }
    }
    
    private func createSubviews() {
        let buttonSize = frame.width * 0.175
        let defaultSize = frame.width - 80
        let playButtonSize = frame.width * 0.25
        let skipButtonSize = playButtonSize * 0.85
        let labelFrame = CGRect(origin: .zero, size: CGSize(width: 1, height: 20))
        let sliderFrame = CGRect(origin: .zero, size: CGSize(width: 1, height: 31))

        backButton = DefaultButton(frame: CGRect(x: frame.minX + 20, y: frame.minY + 40, width: buttonSize, height: buttonSize))
        listButton = DefaultButton(frame: CGRect(x: frame.width - (20 + buttonSize), y: 40, width: buttonSize, height: buttonSize))
        nowPlayingLabel = DefaultLabel(frame: CGRect(center: CGPoint(x: frame.midX, y: backButton.frame.center.y), size: CGSize(width: frame.width - (buttonSize * 2 + 40), height: 20)), text: "Paused")
        artworkImageView = DefaultImageView(frame: CGRect(x: 40, y: backButton.frame.maxY, width: defaultSize, height: defaultSize))
        songNameLabel = DefaultLabel(frame: CGRect(x: artworkImageView.frame.minX, y: artworkImageView.frame.maxY + 24, width: defaultSize, height: 33), text: Song.noSong.title)
        explicitImage = UIImageView(frame: CGRect(center: CGPoint(x: songNameLabel.frame.maxX + 8, y: songNameLabel.frame.center.y), size: CGSize(width: 20, height: 20)))
        artistNameLabel = DefaultLabel(frame: CGRect(x: 40, y: songNameLabel.frame.maxY + 5, width: defaultSize, height: 20), text: Song.noSong.artist)
        currentTimeLabel = DefaultLabel(frame: labelFrame, text: "0:00")
        totalTimeLabel = DefaultLabel(frame: labelFrame, text: "0:00")
        timeSlider = DefaultSlider(frame: sliderFrame)
        timeLabelStackView = UIStackView(frame: CGRect(origin: .zero, size: CGSize(width: 1, height: 20)))
        timeStackView = UIStackView(frame: CGRect(x: 40, y: artistNameLabel.frame.maxY, width: defaultSize, height: 50))
        pausePlayButton = DefaultButton(frame: CGRect(center: CGPoint(x: frame.width / 2, y: frame.maxY - (playButtonSize / 2 + 20)), size: CGSize(width: playButtonSize, height: playButtonSize)))
        skipBackButton = DefaultButton(frame: CGRect(center: CGPoint(x: pausePlayButton.frame.minX - (skipButtonSize / 2 + 32), y: pausePlayButton.frame.center.y), size: CGSize(width: skipButtonSize, height: skipButtonSize)))
        skipForwardButton = DefaultButton(frame: CGRect(center: CGPoint(x: pausePlayButton.frame.maxX + (skipButtonSize / 2 + 32), y: pausePlayButton.frame.center.y), size: CGSize(width: skipButtonSize, height: skipButtonSize)))

        
        subs = [backButton, listButton, nowPlayingLabel, artworkImageView, songNameLabel, explicitImage, artistNameLabel,
        currentTimeLabel, totalTimeLabel, timeSlider, skipBackButton, skipForwardButton, pausePlayButton]
        
        for view in subs {
            if let btn = view as? DefaultButton {
                self.btns.append(btn)
            }
        }
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        for view in subs {
            addSubview(view)
        }
        
        addSubview(timeStackView)
        
        backButton.imageName = "arrow.left"
        listButton.imageName = "line.horizontal.3"
        
        songNameLabel.font = font.withSize(28)
        artistNameLabel.font = font
        nowPlayingLabel.font = font
        
        explicitImage.contentMode = .scaleAspectFit
        explicitImage.image = UIImage(systemName: "e.square.fill")
        explicitImage.tintColor = .buttonColor
        
        currentTimeLabel.textAlignment = .left
        
        totalTimeLabel.textAlignment = .right
        
        timeLabelStackView.distribution = .fillEqually
        timeLabelStackView.axis = .horizontal
        timeLabelStackView.addArrangedSubview(currentTimeLabel)
        timeLabelStackView.addArrangedSubview(totalTimeLabel)
        
        timeStackView.axis = .vertical
        timeStackView.addArrangedSubview(timeLabelStackView)
        timeStackView.addArrangedSubview(timeSlider)
        
        skipBackButton.imageName = "backward.fill"
        skipForwardButton.imageName = "forward.fill"
        
        pausePlayButton.buttonTintColor = .white
        skipBackButton.buttonTintColor = .white
        skipForwardButton.buttonTintColor = .white
        
        for view in subs {
            if let deview = view as? DefaultView {
                deview.setInitialFrame()
                insertSubview(deview.shadowView, at: 0)
                deview.setupShadows()
            }
        }
    }
    
    private func updateGradient() {
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
        
        let buttonColors = settingsController.buttonGradient
        
        for view in subs {
            if let deview = view as? DefaultView {
                deview.colors = [buttonColors.0.cgColor, buttonColors.1.cgColor]
            }
        }
        
        playerStateChanged(isPlaying: musicPlayer.isPlaying)
    }
    
    private func updateViews() {
        let song = currentSong ?? musicPlayer.song
        
        artworkImageView.setImage(song.artwork)
        totalTimeLabel.text = song.duration.stringTime
        artistNameLabel.text = song.artist
        songNameLabel.text = song.title
        timeSlider.maximumValue = Float(song.duration)
        updateTime()
        explicitImage.isHidden = !song.isExplicit
    }
    
    private func updateTime() {
        currentTimeLabel.text = musicPlayer.currentPlaybackTime.stringTime
        timeSlider.value = Float(musicPlayer.currentPlaybackTime)
    }
    
    private func tap() {
        jiggler.impactOccurred()
    }
    
    private func setupButtons() {
        backButton.action = { [unowned self] in
            self.tap()
        }
        
        listButton.action = { [unowned self] in // TODO: - Add action
            self.tap()
        }
        
        skipBackButton.action = { [unowned self] in
            self.tap()
            self.musicPlayer.skipBack()
        }
        
        skipForwardButton.action = { [unowned self] in
            self.tap()
            self.musicPlayer.skipForward()
        }
        
        pausePlayButton.action = { [unowned self] in
            self.tap()
            musicPlayer.toggle()
        }
    }
    
    private func prepareToPlay(_ songCategory: SongCategory = .all) {
        musicPlayer.setSongList(songCategory)
    }
    
    private func getSize(with title: String, font: UIFont) -> CGRect {
        var size = title.size(in: font)
        let defaultSize = isOpen ? frame.width - 80 : skipBackButton.frame.minX - artworkImageView.frame.maxX - 16
        
        if size.width > defaultSize {
            size.width = defaultSize
        }
        
        songNameLabel.frame.size = size
        
        if isOpen {
            size.width -= 24
            return CGRect(center: CGPoint(x: artworkImageView.center.x, y: artworkImageView.frame.maxY), size: size)
        } else {
            return CGRect(center: CGPoint(x: artworkImageView.frame.maxX + 8, y: artworkImageView.frame.midY - size.height / 2), size: size)
        }
    }
    
    private func animate(at fractionComplete: CGFloat = -1, shouldOpen: Bool? = nil) {
        if shouldOpen != nil || fractionComplete == -1 {
            animator.isReversed = shouldOpen!
            isOpen = shouldOpen!
        } else if fractionComplete >= 0 && fractionComplete <= 1 {
            animator.fractionComplete = fractionComplete
        }
    }
    
    private func getCloseAnimation() -> () -> Void {
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        let newFrame = CGRect(x: 0, y: frame.height - 100, width: frame.width, height: 100)
        let backFrame = CGRect(x: backButton.frame.minX - frame.width, y: backButton.frame.minY, width: backButton.frame.width, height: backButton.frame.height)
        let listFrame = CGRect(x: listButton.frame.minX + listButton.frame.width + 40, y: listButton.frame.minY, width: listButton.frame.width, height: listButton.frame.height)
        let artworkFrame = CGRect(x: 8, y: 8, width: newFrame.height - 16, height: newFrame.height - 16)
        let skipForwardButtonFrame = CGRect(x: frame.maxX - 40, y: (newFrame.height - 36) / 2, width: 36, height: 36)
        let pausePlayButtonFrame = CGRect(x: skipForwardButtonFrame.minX - 40, y: skipForwardButtonFrame.minY, width: 36, height: 36)
        let skipBackButtonFrame = CGRect(x: pausePlayButtonFrame.minX - 40, y: pausePlayButtonFrame.minY, width: 36, height: 36)
        let nowPlayingFrame = CGRect(origin: CGPoint(x: nowPlayingLabel.frame.minX - frame.width, y: nowPlayingLabel.frame.minY), size: nowPlayingLabel.frame.size)
        
        let titleLabelFrame = CGRect(x: artworkFrame.maxX + 8, y: artworkFrame.midY - songNameLabel.frame.height / 2, width: skipBackButtonFrame.minX - artworkFrame.maxX - 16, height: songNameLabel.frame.height)
    
        return { [unowned self] in
            self.frame = newFrame
            self.backButton.frame = backFrame
            self.listButton.frame = listFrame
            self.artworkImageView.frame = artworkFrame
            self.pausePlayButton.frame = pausePlayButtonFrame
            self.skipBackButton.frame = skipBackButtonFrame
            self.skipForwardButton.frame = skipForwardButtonFrame
            self.nowPlayingLabel.frame = nowPlayingFrame
            songNameLabel.frame = songNameLabel.frame.changeSize(titleLabelFrame.size)
            self.songNameLabel.font = font
            
            for btn in self.btns {
                btn.button.imageView?.layer.transform = CATransform3DIdentity
            }
            
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    func dragView(_ sender: UIPanGestureRecognizer) {
        let fractionComplete = sender.translation(in: self).y / initialFrame.height - 100
        
        switch sender.state {
        case .began:
            animator.pauseAnimation()
            animator.pausesOnCompletion = true
        case .changed:
            animator.isReversed = !(previousTranslation < fractionComplete)
            
            if fractionComplete <= 1 && fractionComplete >= 0 {
                print("\(fractionComplete), open: \(isOpen)")
                animate(at: fractionComplete)
            }
            
            if (fractionComplete > 0.15 && isOpen) || (fractionComplete < 0.85 && !isOpen) {
                fallthrough
            }
        case .ended:
            if animator.isRunning {
                animator.pauseAnimation()
            }
            
            isOpen = isOpen ? fractionComplete >= 0.05 : fractionComplete < 0.95
        default:
            break
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
        updateTime()
    }
    
    func sliderChanged(_ sender: UISlider) {
        guard let time = TimeInterval(exactly: sender.value) else { return }
        musicPlayer.set(time: time)
    }
}


extension NowPlayingView: MusicPlayerDelegate {
    internal func playerStateChanged(isPlaying: Bool) {
        timeSlider?.playerStatusUpdated(isPlaying: isPlaying)
        
        if isPlaying {
            if currentSong != musicPlayer.song {
                currentSong = musicPlayer.song
            }
            
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
    
    internal func songChanged(song: Song) {
        currentSong = musicPlayer.song
    }
}
