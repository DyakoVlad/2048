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
        titleLabel?.font            = UIFont.systemFont(ofSize: 18, weight: .bold)
        setTitleColor(UIColor(rgb: 0x2c2d2e), for: .normal)
        addTarget(self, action: #selector(pulse), for: .touchUpInside)
    }
    
    @objc func pulse() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration              = 0.2
        pulse.fromValue             = 1.0
        pulse.toValue               = 1.05
        pulse.autoreverses          = false
        pulse.repeatCount           = 0
        pulse.initialVelocity       = 0.5
        pulse.damping               = 10
        
        layer.add(pulse, forKey: "pulse")
    }
}
