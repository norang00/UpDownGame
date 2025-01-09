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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleView.layer.cornerRadius = 30
        circleView.backgroundColor = .white
    }

    func configureData(_ number: Int) {
        numberLabel.text = "\(number+1)"
    }
}
