//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Jacquin Wynn Jr on 3/9/15.
//  Copyright (c) 2015 JMW. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathURL: NSURL!
    var title: String!
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}
