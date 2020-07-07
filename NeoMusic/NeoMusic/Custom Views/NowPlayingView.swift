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
    
    var subs = [UIView]()
    var initialFrame: CGRect
    var initialSongNameFrame: CGRect!
    var translation: CGFloat = 0
    var settingsController: SettingsController?
    let gradientLayer = CAGradientLayer()
    var colors = [UIColor.topGradientColor.cgColor, UIColor.bottomGradientColor.cgColor]
    var hasBeenSetup = false
    var isOpen = true {
        didSet {
            for view in subs {
                if let button = view as? DefaultButton, let layer = button.button.imageView?.layer {
                    layer.transform = isOpen ? CATransform3DMakeScale(1.5, 1.5, 1.5) : CATransform3DIdentity
                }
            }
        }
    }
    var currentSong: Song? {
        didSet {
            updateViews()
        }
    }
    
    private var backButton: DefaultButton!
    private var listButton: DefaultButton!
    private var nowPlayingLabel: UILabel!
    private var artworkImageView: DefaultImageView!
    private var songNameLabel: UILabel!
    private var explicitImage: UIImageView!
    private var artistNameLabel: UILabel!
    private var timeStackView: UIStackView!
    private var timeLabelStackView: UIStackView!
    private var currentTimeLabel: UILabel!
    private var totalTimeLabel: UILabel!
    private var timeSlider: DefaultSlider!
    private var skipBackButton: DefaultButton!
    private var skipForwardButton: DefaultButton!
    private var pausePlayButton: DefaultButton!
    
    
    // MARK: - Superclass Functions

    override init(frame: CGRect) {
        initialFrame = frame
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        initialFrame = CGRect()
        super.init(coder: coder)
        
        initialFrame = frame
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupShadows()
    }
    
    // MARK: - Public Functions
    
    func toggle(_ bool: Bool? = nil) {
        if let bool = bool {
            bool ? open() : close()
        } else {
            isOpen ? close() : open()
        }
    }
    
    // MARK: - Private Functions
    
    private func setup() {
        createSubviews()
        
        currentSong = musicPlayer?.song
        
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.isMultipleTouchEnabled = true
        artworkImageView.jiggler = jiggler
        
        updateGradient()
        layer.insertSublayer(gradientLayer, at: 0)
        
        timeSlider.delegate = self
        timeSlider.minimumValue = 0
        
        setupButtons()
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragView)))
        
        close()
    }
    
    private func createSubviews() {
        let buttonSize = frame.width * 0.175
        let defaultSize = frame.width - 80
        let playButtonSize = frame.width * 0.25
        let skipButtonSize = playButtonSize * 0.85
        
        let backButtonFrame = CGRect(x: frame.minX + 20, y: frame.minY + 40, width: buttonSize, height: buttonSize)
        let listButtonFrame = CGRect(x: frame.width - (20 + buttonSize), y: 40, width: buttonSize, height: buttonSize)
        let nowPlayingLabelFrame = CGRect(center: CGPoint(x: frame.midX, y: backButtonFrame.center.y), size: CGSize(width: frame.width - (buttonSize * 2 + 40), height: 20))
        let artworkImageViewFrame = CGRect(x: 40, y: backButtonFrame.maxY, width: defaultSize, height: defaultSize)
        initialSongNameFrame = CGRect(x: artworkImageViewFrame.minX, y: artworkImageViewFrame.maxY + 16, width: defaultSize, height: 33)
        let explicitImageFrame = CGRect(center: CGPoint(x: initialSongNameFrame.maxX + 8, y: initialSongNameFrame.center.y), size: CGSize(width: 20, height: 20))
        let artistNameLabelFrame = CGRect(x: 40, y: initialSongNameFrame.maxY + 5, width: defaultSize, height: 20)
        let labelFrame = CGRect(origin: .zero, size: CGSize(width: 1, height: 20))
        let sliderFrame = CGRect(origin: .zero, size: CGSize(width: 1, height: 31))
        let timeLabelStackViewFrame = CGRect(origin: .zero, size: CGSize(width: 1, height: 20))
        let timeStackViewFrame = CGRect(x: 40, y: artistNameLabelFrame.maxY + 16, width: defaultSize, height: 50)
        let pausePlayButtonFrame = CGRect(center: CGPoint(x: frame.width / 2, y: frame.maxY - (playButtonSize / 2 + 20)), size: CGSize(width: playButtonSize, height: playButtonSize))
        let skipBackButtonFrame = CGRect(center: CGPoint(x: pausePlayButtonFrame.minX - (skipButtonSize / 2 + 32), y: pausePlayButtonFrame.center.y), size: CGSize(width: skipButtonSize, height: skipButtonSize))
        let skipForwardButtonFrame = CGRect(center: CGPoint(x: pausePlayButtonFrame.maxX + (skipButtonSize / 2 + 32), y: pausePlayButtonFrame.center.y), size: CGSize(width: skipButtonSize, height: skipButtonSize))
        
        backButton = DefaultButton(frame: backButtonFrame)
        listButton = DefaultButton(frame: listButtonFrame)
        nowPlayingLabel = UILabel(frame: nowPlayingLabelFrame)
        artworkImageView = DefaultImageView(frame: artworkImageViewFrame)
        songNameLabel = UILabel(frame: initialSongNameFrame)
        explicitImage = UIImageView(frame: explicitImageFrame)
        artistNameLabel = UILabel(frame: artistNameLabelFrame)
        currentTimeLabel = UILabel(frame: labelFrame)
        totalTimeLabel = UILabel(frame: labelFrame)
        timeSlider = DefaultSlider(frame: sliderFrame)
        timeLabelStackView = UIStackView(frame: timeLabelStackViewFrame)
        timeStackView = UIStackView(frame: timeStackViewFrame)
        skipBackButton = DefaultButton(frame: skipBackButtonFrame)
        skipForwardButton = DefaultButton(frame: skipForwardButtonFrame)
        pausePlayButton = DefaultButton(frame: pausePlayButtonFrame)
        
        subs = [backButton, listButton, nowPlayingLabel, artworkImageView, songNameLabel, explicitImage, artistNameLabel,
        currentTimeLabel, totalTimeLabel, timeSlider, skipBackButton, skipForwardButton, pausePlayButton]
        
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
        
        songNameLabel.font = UIFont.systemFont(ofSize: 28)
        songNameLabel.textAlignment = .center
        
        explicitImage.contentMode = .scaleAspectFit
        explicitImage.image = UIImage(systemName: "e.square.fill")
        explicitImage.tintColor = .buttonColor
        
        artistNameLabel.font = font
        artistNameLabel.textAlignment = .center
        
        nowPlayingLabel.font = font
        nowPlayingLabel.textAlignment = .center
        
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
        
        playerStatusUpdated()
    }
    
    private func setupShadows() {
        for view in subs {
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
        timeSlider.maximumValue = Float(song.duration)
        updateTime()
        explicitImage.isHidden = !song.isExplicit
        
        setTitleWidth()
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
    
    private func setTitleWidth() {
        guard let title = songNameLabel.text, let font = songNameLabel.font else { return }
        
        let attribute = [NSAttributedString.Key.font: font]
        var size = (title as NSString).size(withAttributes: attribute)
        let defaultSize = isOpen ? frame.width - 80 : skipBackButton.frame.minX - artworkImageView.frame.maxX - 16
        
        if size.width > defaultSize {
            size.width = defaultSize
        }
        
        songNameLabel.frame.size = size
        
        if isOpen {
            songNameLabel.center = CGPoint(x: artworkImageView.center.x, y: artworkImageView.frame.maxY + 16)
        } else {
            songNameLabel.center = CGPoint(x: songNameLabel.center.x, y: artworkImageView.center.y)
        }
    }
    
    private func showHide() {
        backButton.isHidden = !isOpen
        listButton.isHidden = !isOpen
        nowPlayingLabel.isHidden = !isOpen
    }
    
    private func open() {
        isOpen = true
        
        let font = UIFont.systemFont(ofSize: 28)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = self.initialFrame
            self.artworkImageView.frame = self.artworkImageView.initialFrame
            self.songNameLabel.frame = self.initialSongNameFrame
            self.pausePlayButton.frame = self.pausePlayButton.initialFrame
            self.skipBackButton.frame = self.skipBackButton.initialFrame
            self.skipForwardButton.frame = self.skipForwardButton.initialFrame
            self.songNameLabel.font = font
            
            self.layoutIfNeeded()
        }) { _ in
            self.showHide()
            self.setTitleWidth()
        }
    }
    
    private func close() {
        isOpen = false
        
        let font = UIFont.boldSystemFont(ofSize: 17)
        
        let newFrame = CGRect(x: 0, y: frame.height - 100, width: frame.width, height: 100)
        let artworkImageViewFrame = CGRect(x: 8, y: 8, width: newFrame.height - 16, height: newFrame.height - 16)
        let skipForwardButtonFrame = CGRect(x: frame.maxX - 40, y: (newFrame.height - 36) / 2, width: 36, height: 36)
        let pausePlayButtonFrame = CGRect(x: skipForwardButtonFrame.minX - 40, y: skipForwardButtonFrame.minY, width: 36, height: 36)
        let skipBackButtonFrame = CGRect(x: pausePlayButtonFrame.minX - 40, y: pausePlayButtonFrame.minY, width: 36, height: 36)
        let titleLabelFrame = CGRect(x: artworkImageViewFrame.maxX + 8, y: artworkImageViewFrame.minY + songNameLabel.frame.height / 2, width: skipBackButtonFrame.minX - artworkImageViewFrame.maxX - 16, height: artworkImageViewFrame.height)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame = newFrame
            self.artworkImageView.frame = artworkImageViewFrame
            self.pausePlayButton.frame = pausePlayButtonFrame
            self.skipBackButton.frame = skipBackButtonFrame
            self.skipForwardButton.frame = skipForwardButtonFrame
            self.songNameLabel.frame = titleLabelFrame
            self.songNameLabel.font = font
            
            self.layoutIfNeeded()
        }) { _ in
            self.showHide()
            self.setTitleWidth()
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
        let currentTranslation = sender.translation(in: self).y
        translation += currentTranslation
        
        if sender.state == .began || sender.state == .changed {
            if isOpen && translation > 10 {
                close()
            } else if translation < -10 {
                open()
            }
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
