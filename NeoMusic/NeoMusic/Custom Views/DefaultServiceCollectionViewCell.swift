//
//  DefaultServiceCollectionViewCell.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

protocol DefaultServiceCollectionViewCellDelegate: AnyObject {
    func serviceConnected(type: SongType)
}

class DefaultServiceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    weak var delegate: DefaultServiceCollectionViewCellDelegate?
    
    var jiggler: UIImpactFeedbackGenerator?
    var type: SongType? {
        didSet {
            if let type = type {
                setImage(UIImage(named: type.rawValue))
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var connectServiceButton: UIButton!
    
    // MARK: - Superclass Functions

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    func setup() {
        connectServiceButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        connectServiceButton.imageView?.contentMode = .scaleAspectFit
        connectServiceButton.contentMode = .scaleAspectFit
        backgroundColor = .clear
    }
    
    private func setImage(_ image: UIImage?) {
        connectServiceButton.setImage(image, for: .normal)
    }

    // MARK: - Private Functions
    
    private func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
    
    // MARK: - Objective-C Functions
    
    @objc
    private func buttonTapped(_ sender: UIButton) {
        guard let type = type else { return }
        
        delegate?.serviceConnected(type: type)
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard isUserInteractionEnabled, !isHidden, alpha >= 0.01, self.point(inside: point, with: event) else { return nil }
        
        if connectServiceButton.point(inside: convert(point, to: connectServiceButton), with: event) {
            return connectServiceButton
        }
        
        return super.hitTest(point, with: event)
    }
}
