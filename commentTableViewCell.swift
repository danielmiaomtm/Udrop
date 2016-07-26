//
//  commentTableViewCell.swift
//  Udrop
//
//  Created by Tianming Miao on 7/26/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import Alamofire
import Spring
import SwiftyJSON
import Foundation

protocol commentTableViewCellDelegate: class {
    func commentTableViewCellLikeButtonPressed(cell: commentTableViewCell, sender: AnyObject)
    func commentTableViewCellcommentPressed(cell: commentTableViewCell, sender: AnyObject)
    func commentTableViewCellProfilePressed(cell: commentTableViewCell, sender: AnyObject)
}

class commentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selfLikedImage: UIImageView!
    
    @IBOutlet weak var profile: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var likesNumber: UILabel!
    
    @IBOutlet weak var commentsNumber: UILabel!
    
    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var selfLiked: UIButton!
    
    @IBOutlet weak var LikeAndCommentFrame: UIView!
    
    weak var delegate: commentTableViewCellDelegate?
    
    var postId = 0
    
    var likeNumber = 0
    
    var postSelfLiked = false
    
    var count = 0
    
    var userId = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.LikeAndCommentFrame.layer.borderColor = UIColor.colorWithHex("#D2D2D2", alpha: 0.36).CGColor
        self.LikeAndCommentFrame.layer.borderWidth = 1
        
        self.likeNumber = 0
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        
        delegate?.commentTableViewCellLikeButtonPressed(self, sender: sender)
    }
    
    @IBAction func commentPressed(sender: AnyObject) {
        
        delegate?.commentTableViewCellcommentPressed(self, sender: sender)
        
    }
    
    @IBAction func profilepressed(sender: AnyObject) {
        
        delegate?.commentTableViewCellProfilePressed(self, sender: sender)
    }
    
    @IBAction func profileokay(sender: AnyObject) {
        print("测试正常")
    }
    
    func configureWithCommentsJSON(data: JSON) {
        let userProfile = data["userLogo"].string ?? ""
        let userName = data["userName"].string ?? ""
        let userTime = data["creationDatetime"].int!
        let userLikesNumber = data["numOfLikes"].int!
        let userCommentNumber = data["numOfComments"].int!
        let userMessage = data["content"].string ?? ""
        let userSelfLiked = data["isLiked"].bool!
        self.postId = data["postId"].int!
        self.postSelfLiked = userSelfLiked
        self.likeNumber = userLikesNumber
        
        //时间
        let PostTimeData = String(stringInterpolationSegment: userTime)
        let theDate = NSDate(jsonDate:"/Date(" + PostTimeData + ")/")
        //把theDate转换成String
        let myDate = String(stringInterpolationSegment: theDate!)
        let projectPostTime = timeAgoSinceDate(dateFromString(myDate, format: "yyyy-MM-dd HH:mm:ssZ"), numericDates: true)
        //头像
        let profileData = CommonURL.userLogoURL + userProfile
        Alamofire.request(.GET, profileData).response() {
            (_, _, data, _) in
            
            let image = UIImage(data: data! as! NSData)
            self.profile.image = image
        }
        if userSelfLiked == true {
            selfLikedImage.image = UIImage(named: "likeImage")
        }else{
            selfLikedImage.image = UIImage(named: "unlikeImage")
        }
        //名字
        time.text = projectPostTime
        name.text = userName
        
        likesNumber.text = String(stringInterpolationSegment: userLikesNumber)
        
        self.likeNumber = userLikesNumber
        
        commentsNumber.text = String(userCommentNumber)
        
        message.text = userMessage
        
    }
    
    
    func configureWithComments(data: postsLoadingData){
        let userProfile = data.userLogo as String
        let userName = data.userName as String
        let userTime = data.creationDatetime as Int
        let userLikesNumber = data.numOfLikes as Int
        let userCommentNumber = data.numOfComments as Int
        let userMessage = data.content as String
        let userComment = ""
        let userSelfLiked = data.isLike as Bool
        self.postId = data.postId as Int
        self.postSelfLiked = data.isLike as Bool
        self.likeNumber = userLikesNumber
        
        
        //时间
        let PostTimeData = String(userTime)
        let theDate = NSDate(jsonDate:"/Date(" + PostTimeData + ")/")
        //把theDate转换成String
        let myDate = String(stringInterpolationSegment: theDate!)
        let projectPostTime = timeAgoSinceDate(dateFromString(myDate, format: "yyyy-MM-dd HH:mm:ssZ"), numericDates: true)
        //头像
        let profileData = CommonURL.userLogoURL + userProfile
        Alamofire.request(.GET, profileData).response() {
            (_, _, data, _) in
            
            let image = UIImage(data: data! )
            self.profile.image = image
        }
        if userSelfLiked == true {
            selfLikedImage.image = UIImage(named: "likeImage")
        }else{
            selfLikedImage.image = UIImage(named: "unlikeImage")
        }
        //名字
        time.text = projectPostTime
        name.text = userName
        
        likesNumber.text = String(userLikesNumber)
        
        self.likeNumber = userLikesNumber
        
        commentsNumber.text = String(userCommentNumber)
        
        message.text = userMessage
        
    }
      
}

extension NSDate {
    convenience init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        let scanner = NSScanner(string: jsonDate)
        
        //        // Check prefix:
        if scanner.scanString(prefix, intoString: nil) {
            
            //Read milliseconds part:
            var milliseconds : Int64 = 0
            if scanner.scanLongLong(&milliseconds) {
                // Milliseconds to seconds:
                var timeStamp = NSTimeInterval(milliseconds)/1000.0
                
                // Read optional timezone part:
                var timeZoneOffset : Int = 0
                if scanner.scanInteger(&timeZoneOffset) {
                    let hours = timeZoneOffset / 100
                    let minutes = timeZoneOffset % 100
                    // Adjust timestamp according to timezone:
                    timeStamp += NSTimeInterval(3600 * hours + 60 * minutes)
                }
                
                // Check suffix:
                if scanner.scanString(suffix, intoString: nil) {
                    // Success! Create NSDate and return.
                    self.init(timeIntervalSince1970: timeStamp)
                    return
                }
            }
        }
        
        // Wrong format, return nil. (The compiler requires us to
        // do an initialization first.)
        self.init(timeIntervalSince1970: 0)
        return nil
    }
}

