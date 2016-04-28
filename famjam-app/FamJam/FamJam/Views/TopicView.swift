//
//  TopicView.swift
//  FamJam
//
//  Created by Roger Chen on 4/27/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import CodePush
import React
import UIKit

class TopicView : UIView {
    
    let rootView: RCTRootView = RCTRootView(
        bundleURL: NSBundle.mainBundle().URLForResource("main", withExtension: "jsbundle"),
        moduleName: "TopicView",
        initialProperties: [
            "id": "571c0b1d9ad4be1100057554",
            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI1NzFiYjkzZjg1YzZiNTExMDA1MjI4ODAiLCJpYXQiOjE0NjE3NDU5NDh9.xUlHWLUAk_cgn_T5oLdWJ0oeFJIQ6IXsqOLZR02hr2o"
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