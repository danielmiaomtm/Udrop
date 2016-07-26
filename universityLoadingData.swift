//
//  File.swift
//  Udrop
//
//  Created by Tianming Miao on 7/25/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import Foundation

/**
 meetupLoadingData Class
 */
class universityLoadingData: NSObject {
    
    var name = NSString()
    var country = NSString()
    var state = NSString()
    var city = NSString()
    var logo = NSString()
    var cover = NSString()
    var views = Int()
    var universityId = Int()
    var numOfFollowers = Int()
    var isFollowed = Bool()
    
    var introduction = String()
}