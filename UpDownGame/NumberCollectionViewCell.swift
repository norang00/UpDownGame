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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        numberLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        circleView.layer.cornerRadius = 30
        circleView.layer.borderColor = UIColor.black.cgColor
        circleView.layer.borderWidth = 2
    }

    func configureData(_ number: Int) {
        numberLabel.text = "\(number)"
    }
    
    func highlightCell() {
        circleView.backgroundColor = .cantaloupe
        numberLabel.textColor = .black
        numberLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }
}
