//
//  DefaultSlider.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 5/31/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

protocol DefaultSliderDelegate: AnyObject {
    func timerFired()
    func sliderChanged(_ sender: UISlider)
}

class DefaultSlider: UISlider {
    
    // MARK: - Variables
    
    weak var delegate: DefaultSliderDelegate?
    var timer: Timer?
    var isEditing = false
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        updateViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        updateViews()
    }
    
    // MARK: - Superclass Functions

    override func layoutSubviews() {
        super.layoutSubviews()
        tintColor = .trackYellowColor
    }
    
    // MARK: - Private Functions
    
    private func updateViews() {
        addTarget(self, action: #selector(sliderEditing), for: .editingDidEnd)
        addTarget(self, action: #selector(sliderReleased), for: .touchUpInside)
        
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    private func sliderEditing() {
        isEditing = true
    }
    
    @objc
    private func sliderReleased() {
        delegate?.sliderChanged(self)
        isEditing = false
    }
    
    @objc
    func playerStatusUpdated(isPlaying: Bool) {
        if isPlaying {
            self.timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: true)
        } else {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc
    private func timerFired() {
        if !isEditing, let delegate = delegate {
            delegate.timerFired()
        }
    }

}
