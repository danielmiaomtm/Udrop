//
//  groupCell_TableViewCell.swift
//  Udrop
//
//  Created by Tianming Miao on 7/25/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import Alamofire
import Haneke
import SwiftyJSON
import Foundation

protocol groupCell_TableViewCellDelegate: class {
    func followButtonDidPressed(cell: groupCell_TableViewCell, sender: AnyObject)
}


class groupCell_TableViewCell: UITableViewCell {

    @IBOutlet weak var memberNumber: UILabel!
    @IBOutlet weak var intro: UITextView!
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var locaiton: UILabel!
    @IBOutlet weak var flag: UIImageView!
    @IBOutlet weak var followUniversityImage: UIImageView!
    
    @IBOutlet weak var logoBackground: UIImageView!
    
    var count = 0
    var isFollowed = false
    var universityIdForButton = 0
    
    weak var delegate : groupCell_TableViewCellDelegate?
    
    //    weak var delegate: StoryTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        logoBackground.layer.masksToBounds = true
        logoBackground.layer.cornerRadius = 30
        
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 30
    }
    
    // fisrt cell is about the detail information and background image of university
    func configureWithCell(university: universityLoadingData) {
        let universityName = university.name as String
        let universitylocation = university.country as String
        let universityLogo = university.logo as String
        let universityFlag = university.country as String
        let universityBackground = university.cover as String
        let universityViews = university.views as Int
        let universitynumOfFollowers = university.numOfFollowers as Int
        let universityId = university.universityId as Int
        let universityIsFollowed = university.isFollowed as Bool
        
        //get the cover and background image
        let backgroundImage = CommonURL.universityCoverURL + universityBackground
        let URL = NSURL(string:backgroundImage)!
        self.background.hnk_setImageFromURL(URL)
        
        
        //get the national flag
        let encodedMessage = universityFlag.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let url = CommonURL.countryLogoURL + encodedMessage! + "Flag.png"
        Alamofire.request(.GET, url).response() {
            (_,_,data,_) in
            let image = UIImage(data: data! )
            self.flag.image = image
        }
        
        //get the university logo
        let logoData = CommonURL.universityLogoURL + universityLogo
        Alamofire.request(.GET, logoData).response() {
            (_, _, data, _) in
            
            let logoImage = UIImage(data: data! )
            self.logo.image = logoImage
        }
        
        name.text = universityName
        locaiton.text = universitylocation
        
    }
    
    
    //fisrt cell is about the detail information and background image of university
    func configureWithPlisData(university: [String: AnyObject]) {
        let universityName = university["name"] as! String
        let universitylocation = university["country"] as! String
        let universityLogo = university["logo"] as! String
        let universityFlag = university["country"] as! String
        let universityBackground = university["cover"] as! String
        let universityViews = university["views"] as! Int
        let universitynumOfFollowers = university["numOfFollowers"] as! Int
        let universityId = university["universityId"] as! Int
        let universityIsFollowed = university["isFollowed"] as! Bool
        
        //get the university cover，background
        let backgroundImage = CommonURL.universityCoverURL + universityBackground
        let URL = NSURL(string:backgroundImage)!
        self.background.hnk_setImageFromURL(URL)
        
        
        //get the national flag
        let encodedMessage = universityFlag.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let url = CommonURL.countryLogoURL + encodedMessage! + "Flag.png"
        Alamofire.request(.GET, url).response() {
            (_,_,data,_) in
            let image = UIImage(data: data! as! NSData)
            self.flag.image = image
        }
        
        //get the university logo
        let logoData = CommonURL.universityLogoURL + universityLogo
        Alamofire.request(.GET, logoData).response() {
            (_, _, data, _) in
            
            let logoImage = UIImage(data: data! as! NSData)
            self.logo.image = logoImage
        }
        
        name.text = universityName
        locaiton.text = universitylocation
        
    }
    
    
    
    /*************************************************************************************************/
    //second cell is about the post detail and comments of university
    func configureWithCell2(university: JSON) {
        let universityName = university["name"].string ?? ""
        let universitylocation = university["country"].string ?? ""
        let universityLogo = university["logo"].string ?? ""
        let universityFlag = university["country"].string ?? ""
        let universityBackground = university["cover"].string ?? ""
        let universityViews = university["views"].int!
        let universityWeb = university["website"].string ?? ""
        let universityIntro = university["description"].string ?? ""
        let universityFollowers = university["numOfFollowers"].int!
        let universityIsFollowed = university["isFollowed"].bool!
        let universityId = university["universityId"].int!
        
        self.universityIdForButton = universityId
        self.isFollowed = universityIsFollowed
        
        if universityIsFollowed {
            self.followUniversityImage.image = UIImage(named: "following")
        }else{
            self.followUniversityImage.image = UIImage(named: "follow")
        }
        
        //get university cover，background
        let profileData = CommonURL.universityCoverURL + universityBackground
        Alamofire.request(.GET, profileData).response() {
            (_, _, data, _) in
            
            let image = UIImage(data: data! as! NSData)
            self.background.image = image
        }
        //get national flag
        let encodedMessage = universitylocation.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        
        let url = CommonURL.countryLogoURL + encodedMessage! + "Flag.png"
        Alamofire.request(.GET, url).response() {
            (_,_,data,_) in
            let image = UIImage(data: data! as! NSData)
            self.flag.image = image
        }
        
        //get university logo
        let logoData = CommonURL.universityLogoURL + universityLogo
        Alamofire.request(.GET, logoData).response() {
            (_, _, data, _) in
            
            let logoImage = UIImage(data: data! as! NSData)
            self.logo.image = logoImage
        }
        
        memberNumber.text = String(universityFollowers)
        name.text = universityName
        locaiton.text = universitylocation
        intro.text = universityIntro
        
        
    }
    
    @IBAction func followButton(sender: AnyObject) {
        delegate?.followButtonDidPressed(self, sender: sender)
        
    }
    

}
