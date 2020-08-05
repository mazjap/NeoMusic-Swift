//
//  DefaultServiceCollectionViewCell.swift
//  NeoMusic
//
//  Created by Jordan Christensen on 6/8/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import UIKit

class DefaultServiceCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let identifier = "DefaultServiceCollectionViewCell"
    
    var jiggler: UIImpactFeedbackGenerator?
    var type: SongType? {
        didSet {
            if let type = type {
                setImage(UIImage(named: type.rawValue))
            }
        }
    }
    
    private var imageView: UIImageView
    
    // MARK: - Superclass Functions
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: frame)
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.imageView = UIImageView()
        super.init(coder: coder)
        
        imageView.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Functions
    func setup() {
        addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFit
    }
    
    private func setImage(_ image: UIImage?) {
        imageView.image = image
    }

    // MARK: - Private Functions
    
    private func tap() {
        guard let jiggler = jiggler else { return }
        jiggler.impactOccurred()
    }
}
