//
//  RestartButton.swift
//  2048 for VK
//
//  Created by Влад Дьяков on 08/05/2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class RestartButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpBtn()
    }
    
    private func setUpBtn() {
        backgroundColor             = UIColor.white
        setTitleColor(UIColor(rgb: 0x2c2d2e), for: .normal)
        titleLabel?.font            = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
}
