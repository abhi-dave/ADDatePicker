//
//  HorizontalCollectionViewCell.swift
//  horizontal-date-picker
//
//  Created by SOTSYS027 on 20/04/18.
//  Copyright © 2018 SOTSYS027. All rights reserved.
//

import UIKit

class ADDatePickerCell: UICollectionViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomBorder: UIView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        bottomBorder.backgroundColor = .white
        self.contentView.addSubview(bottomBorder)
    }

}

extension ADDatePickerCell {

    func selectedCell(textColor: UIColor){
        self.backgroundColor = .clear
        self.dateLbl.textColor = textColor
        self.alpha = 1
    }
//    func selectSelectionType(selectionType: SelectionType){
//        switch selectionType {
//        case .square:
//            self.layer.cornerRadius = 0.0
//            break
//        case .roundedsquare:
//            self.layer.cornerRadius = 5.0
//            break
//        case .circle:
//            self.layer.cornerRadius = self.frame.size.width / 2
//            break
//        }
//    }
    
    func deSelectCell(bgColor: UIColor, textColor: UIColor){
        self.backgroundColor = bgColor
        self.dateLbl.textColor = textColor
        self.alpha = 0.5
    }

}
