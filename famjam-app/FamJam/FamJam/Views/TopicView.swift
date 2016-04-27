//
//  TopicView.swift
//  FamJam
//
//  Created by Roger Chen on 4/27/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import React
import UIKit

class TopicView : UIView {
    
    let rootView: RCTRootView = RCTRootView(
        bundleURL: NSURL(string: "http://192.168.10.112:8081/index.ios.bundle?platform=ios"),
        moduleName: "TopicView",
        initialProperties: [
            "id": "571c0b1d9ad4be1100057554"
        ],
        launchOptions: nil
    )
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loadReact()
    }
    
    func loadReact() {
        addSubview(rootView)
        rootView.frame = self.bounds
    }
    
}