//
//  numberCollectionViewCell.swift
//  UpDownGame
//
//  Created by Kyuhee hong on 1/9/25.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet var circleView: UIView!
    @IBOutlet var numberLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                circleView.backgroundColor = .black
                numberLabel.textColor = .white
            } else {
                circleView.backgroundColor = .white
                numberLabel.textColor = .black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleView.layer.cornerRadius = 30
    
    }

    func configureData(_ number: Int) {
        numberLabel.text = "\(number)"
    }
    
    func highlightCell() {
        circleView.backgroundColor = .blue
        numberLabel.textColor = .white
    }
}
