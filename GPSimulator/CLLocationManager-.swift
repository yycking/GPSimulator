//
//  CLLocationManager-.swift
//  GPSimulatorExample
//
//  Created by Wayne Yeh on 2017/3/9.
//  Copyright © 2017年 Wayne Yeh. All rights reserved.
//

import CoreLocation

private let swizzling: (AnyClass, Selector, Selector) -> () = { forClass, originalSelector, swizzledSelector in
    let originalMethod = class_getInstanceMethod(forClass, originalSelector)
    let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension CLLocationManager {
    open override class func initialize() {
        swizzling(self, Selector(("onClientEventLocation:")), #selector(self.xxx_onClientEventLocation(_:)))
        swizzling(self, Selector(("onClientEventLocation:forceMapMatching:type:")), #selector(self.xxx_onClientEventLocation(_:_:_:)))
    }
    
    @nonobjc static var simulatedLocation: CLLocation?
    func xxx_onClientEventLocation(_ foo: Any) {
        if let location = type(of:self).simulatedLocation {
            delegate?.locationManager?(self, didUpdateLocations: [location])
        } else {
            self.xxx_onClientEventLocation(foo)
        }
    }
    
    func xxx_onClientEventLocation(_ foo: Any, _ foo1: Any, _ foo2: Any) {
        if let location = type(of:self).simulatedLocation {
            delegate?.locationManager?(self, didUpdateLocations: [location])
        } else {
            self.xxx_onClientEventLocation(foo, foo1, foo2)
        }
    }
}
