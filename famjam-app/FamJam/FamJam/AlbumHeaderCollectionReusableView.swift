//
//  AlbumHeaderCollectionReusableView.swift
//  FamJam
//
//  Created by Lucio Tan on 4/24/16.
//  Copyright © 2016 Accord.io. All rights reserved.
//

import UIKit

class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    
    var albumHeaderLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setup()
    }
    
    
    private func setup() {
        albumHeaderLabel.text = ""
        albumHeaderLabel.frame = CGRectMake(self.frame.width/2 - Constants.ALBUM_HEADER_LABEL_WIDTH/2, Constants.ALBUM_HEADER_OFFSET_Y, Constants.ALBUM_HEADER_LABEL_WIDTH, Constants.ALBUM_HEADER_LABEL_HEIGHT)
        albumHeaderLabel.textAlignment = .Center
        albumHeaderLabel.font = Constants.FAMJAM_HEADER_FONT
        albumHeaderLabel.textColor = Constants.FAMJAM_WHITE_COLOR
        self.addSubview(albumHeaderLabel)
        
        
    }
    
    func changeLabelTitle(title: String) {
        albumHeaderLabel.text = title
    }
    
}
