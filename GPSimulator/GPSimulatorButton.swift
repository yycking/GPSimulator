//
//  GPSimulatorButton.swift
//  GPSimulatorExample
//
//  Created by Wayne Yeh on 2017/3/9.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import UIKit
import CoreLocation

class GPSimulatorButton: UIButton {
    let locationManager = CLLocationManager()
    
    init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        let img = UIImage(named: "GPSimulatorButton")
        self.setImage(img, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView?.alpha = 0.3
    }
    
    var rads: CGFloat = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        processRads(touches, with: event)
        fireLongPress()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        processRads(touches, with: event)
    }
    
    private func processRads(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var loc = touch.location(in: self)
        loc.x -= self.frame.width / 2
        loc.y -= self.frame.height / 2
        rads = atan2(loc.x, loc.y) - CGFloat(M_PI*0.5)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @objc private func fireLongPress() {
        guard let location = CLLocationManager.simulatedLocation ?? locationManager.location else { return }
        
        var coordinate = location.coordinate
        coordinate.latitude += 0.0001 * Double(sin(rads))
        coordinate.longitude += 0.0001 * Double(cos(rads))
        
        CLLocationManager.simulatedLocation =
            CLLocation(
                coordinate: coordinate,
                altitude: location.altitude,
                horizontalAccuracy: location.horizontalAccuracy,
                verticalAccuracy: location.verticalAccuracy,
                course: location.course,
                speed: location.speed,
                timestamp: Date()
        )
        
        self.perform(#selector(self.fireLongPress), with: nil, afterDelay: 0.3)
    }
}

