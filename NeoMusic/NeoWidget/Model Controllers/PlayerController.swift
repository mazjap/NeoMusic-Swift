//
//  Player.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 7/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import WidgetKit
import MediaPlayer

class PlayerController: TimelineEntry, ObservableObject {
    let player = MPMusicPlayerController.systemMusicPlayer
    var date: Date

    @Published var currentSong: Song = Song.noSong
    @Published var isPlaying: Bool = false

    var currentPlaybackTime: TimeInterval {
        player.currentPlaybackTime
    }

    var totalPlaybackTime: TimeInterval {
        return currentSong.duration
    }

    init(date: Date = Date()) {
        self.date = date
        player.beginGeneratingPlaybackNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(playbackStatusChanged), name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(songChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)

        playbackStatusChanged()
        songChanged()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerPlaybackStateDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)

        player.endGeneratingPlaybackNotifications()
    }

    func prepareToPlay() {
        player.prepareToPlay()
    }

    func pause() {
        player.pause()
    }

    func play() {
        player.play()
    }

    func setQueue(songs: [Song]) {
        player.setQueue(with: MPMediaItemCollection(items: songs.filter({ $0.media != nil }).map({ $0.media! })))
    }

    func set(time: TimeInterval) {
        player.currentPlaybackTime = time
    }

    func toggle() {
        isPlaying ? pause() : play()
    }

    func skipToPreviousItem() {
        player.skipToPreviousItem()
    }

    func skipToNextItem() {
        player.skipToNextItem()
    }

    @objc
    private func playbackStatusChanged() {
        isPlaying = player.playbackState == .playing
    }

    @objc func songChanged() {
        guard let media = player.nowPlayingItem else { return }

        currentSong = Song(song: media)
        WidgetCenter.shared.reloadAllTimelines()
    }
}
