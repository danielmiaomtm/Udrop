//
//  group_cell_DetailTableViewController.swift
//  Udrop
//
//  Created by Tianming Miao on 7/25/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import Foundation
import SwiftyJSON
import MJRefresh



class group_cell_DetailTableViewController: UITableViewController, commentTableViewCellDelegate,groupCell_TableViewCellDelegate {

    //页码
    var PAGE_NUM  = 0
    /**************************************************************************************/
    var university: JSON! = []
    
    //    var universityInfoData : universityLoadingData?
    
    var universityNameData = ""
    var universitycountryData = ""
    var universityLogoData = ""
    var universityCoverData = ""
    var universityViewsData = 0
    var universityDescriptionData = ""
    var universityNumOfFollowersData = 0
    var universityIsFollowedData = false
    var universityIdData = 0
    var universityGeneralGroupIdData = 0
    var comingFromFollowList = 0
    /**************************************************************************************/
    var userInfo : JSON! = []
    
    //    var myButton : followButton!
    
    var postsLoadingPageData:[postsLoadingData] = []
    
    var postId = 0
    
    var postIsLike = false
    
    let userToken = localStore.getToken()!
    
    var userCommentData: JSON = []
    
    var isChecked = NSUserDefaults.standardUserDefaults().boolForKey("isBtnChecked")
    
    var universityIdForButton = 0
    
    //    var parentNavigationController: UINavigationController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        localStore.deletSavedUniversity(self.universityIdData)
        
        localStore.deletrefreshForPost()
        
        localStore.deletPostNewPost(self.universityGeneralGroupIdData)
        
        universityInfo = self.university
        // Set the navigation title
        self.navigationItem.title = self.universityNameData
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController!.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 18)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: #selector(group_cell_DetailTableViewController.addComment))
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        /**************************************************************************************/
        
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadNewData))
        
        self.tableView.mj_header.beginRefreshing()
        
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadMoreData))
        self.tableView.mj_footer.hidden = true

    }
    
    func addComment() {
        
        addCommentSender = 0
        NewPostId = self.universityIdData
        let newViewController = UINavigationController(rootViewController: PostNewPostViewController())
        PostNewPostViewController().id = self.universityIdData
        
        presentViewController(newViewController, animated: true, completion: nil)
        
    }
    
    //传回来的回复判断是否有发送，如果有的话更新数据
    override func viewWillAppear(animated: Bool) {
        
        let id = self.universityIdData
        
        var IsPostNewPostAction = localStore.getPostNewPost(id)
        
        
        if IsPostNewPostAction == id {
            //刷新数据
            
            self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadNewData))
            
            self.tableView.mj_header.beginRefreshing()
            
            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadMoreData))
            self.tableView.mj_footer.hidden = true
            /**************************************************************************************/
            localStore.deletPostNewPost(self.universityIdData)
        }else {
            
            
        }
        
        
        ////println(self.university)
        ////println(self.university["generalGroupId"].int!)
        //
        //        if localStore.getSaveUniversityId(self.university["generalGroupId"].int!) == self.university["generalGroupId"].int!{
        //println("following")
        ////            universityCellTableViewCell().followUniversityImage.image = UIImage(named: "following")
        //        } else {
        ////            universityCellTableViewCell().followUniversityImage.image = UIImage(named: "follow")
        //println("follow")
        //println(self.university["generalGroupId"].int!)
        //println(localStore.getSaveUniversityId(self.university["generalGroupId"].int!))
        //        }
        //
    }
    
    
    
    
    /**************************************************************************************/
    override func viewDidAppear(animated: Bool) {
        
        self.tableView.tableFooterView = UIView()
        super.viewDidAppear(true)
        self.tableView.showsVerticalScrollIndicator = false
        super.viewDidAppear(animated)
        self.tableView.showsVerticalScrollIndicator = true
    }
    
    
    //关注
    func followButtonDidPressed(cell: groupCell_TableViewCell, sender: AnyObject) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        ////提取是否关注了这个学校
        ////添加学校关注或者取消学校关注
        
        let universityFollowURL = CommonURL.universityURL + "\(self.universityIdData)" + "/follow"
        
        let parameters = [
            "id" : self.universityIdData,
            "isFollowed" : self.universityIsFollowedData,
            "token": self.userToken
        ]
        
        if cell.count == 0{
            //这里的count需要在每一个cell[indexPath.row]里面
            //println("第一次关注")
            //println(cell.universityIdForButton)
            //println(localStore.getSaveUniversityId(cell.universityIdForButton))
            
            cell.count = cell.count + 1
            
            if self.universityIsFollowedData {
                
                cell.followUniversityImage.image = UIImage(named: "follow")
                localStore.deletSavedUniversity(self.universityIdData)
                Alamofire.request(.POST, universityFollowURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                }
                
            }else{
                
                cell.followUniversityImage.image = UIImage(named: "following")
                localStore.saveFollowedUniversity(self.universityIdData)
                
                Alamofire.request(.POST, universityFollowURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                    
                }
            }
        }else{
            //println("已经关注过了")
            //println(localStore.getSaveUniversityId(cell.universityIdForButton))
            if localStore.getSaveUniversityId(self.universityIdData) == self.universityIdData {
                
                cell.followUniversityImage.image = UIImage(named: "follow")
                localStore.deletSavedUniversity(self.universityIdData)
                Alamofire.request(.POST, universityFollowURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                }
                
            }else{
                cell.followUniversityImage.image = UIImage(named: "following")
                localStore.saveFollowedUniversity(self.universityIdData)
                Alamofire.request(.POST, universityFollowURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                }
            }
        }
        
        let delayInSeconds:Int64 = 1000000000 * 1
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
        
    }
    //评论的Button
    func commentTableViewCellcommentPressed(cell: commentTableViewCell, sender: AnyObject) {
        
        addCommentSender = 1
        NewPostId = cell.postId
        let newViewController = UINavigationController(rootViewController: PostNewPostViewController())
        presentViewController(newViewController, animated: true, completion: nil)
    }
    
    //进入合伙人主页
    func commentTableViewCellProfilePressed(cell: commentTableViewCell, sender: AnyObject) {
        
//        var newVC : cofounderProfileTableViewController = cofounderProfileTableViewController()
//        let cofounderURL = CommonURL.userDetail + "\(cell.userId)"
//        let parameters = [
//            "id" : "\(cell.userId)",
//            "token" : localStore.getToken()!
//        ]
//        Alamofire.request(.POST, cofounderURL , parameters: parameters).responseJSON { (_, _, JSON_DATA, _) -> Void in
//            
//            let hoge = JSON(JSON_DATA!)
//            
//            newVC.profile = hoge
//            
//            self.navigationController?.pushViewController(newVC, animated: true)
//        }
    }
    //按赞的Button
    func commentTableViewCellLikeButtonPressed(cell: commentTableViewCell, sender: AnyObject) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let postLikeURL = CommonURL.universityPostURL + "\(cell.postId)" + "/like"
        
        self.postId = cell.postId
        
        var parameters =
            [
                "id" : cell.postId,
                "isLike" : cell.postSelfLiked,
                "token" :  self.userToken
        ]
        
        //判断是否登录
        
        if cell.count == 0{
            //这里的count需要在每一个cell[indexPath.row]里面
            //println("第一次按赞")
            //println(cell.postId)
            cell.count = cell.count + 1
            
            if cell.postSelfLiked {
                
                cell.selfLikedImage.image = UIImage(named: "unlike_Icon")
                cell.likeNumber = cell.likeNumber - 1
                cell.likesNumber.text = String(cell.likeNumber)
                localStore.deleteLikePost(cell.postId)
                
                Alamofire.request(.POST, postLikeURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                    
                }
                
            }else{
                
                cell.selfLikedImage.image = UIImage(named: "like_Icon")
                cell.likeNumber = cell.likeNumber + 1
                cell.likesNumber.text = String(cell.likeNumber)
                localStore.saveLikePosts(cell.postId)
                
                Alamofire.request(.POST, postLikeURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                    
                }
            }
        }else{
            //println("已经按赞过了")
            if userDefaults.integerForKey("postId\(cell.postId)") == cell.postId {
                
                cell.selfLikedImage.image = UIImage(named: "unlike_Icon")
                cell.likeNumber = cell.likeNumber - 1
                cell.likesNumber.text = String(cell.likeNumber)
                localStore.deleteLikePost(cell.postId)
                Alamofire.request(.POST, postLikeURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                }
                
            }else{
                cell.selfLikedImage.image = UIImage(named: "like_Icon")
                cell.likeNumber = cell.likeNumber + 1
                cell.likesNumber.text = String(cell.likeNumber)
                localStore.saveLikePosts(cell.postId)
                Alamofire.request(.POST, postLikeURL, parameters: parameters as? [String : AnyObject]).responseJSON{ response in
                }
            }
        }
        
        let delayInSeconds:Int64 = 1000000000 * 1
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
        
        
        
    }
    
    /**************************************************************************************/
    func loadData(offset:Int){
        //接口url
        let univeristyURL = CommonURL.universityURL + "\(self.universityIdData)"
        let parameters1 = [
            "id" : self.universityIdData,
            "token" : localStore.getToken()!
        ]
        // 请求数据
        Alamofire.request(.POST, univeristyURL,parameters : parameters1 as? [String : AnyObject]).responseJSON { response in
            //        self.universityIsFollowedData
            let JSON_DATA = JSON(data: response.data!)
            if JSON_DATA == nil{
                SCLAlertView().showWarning("温馨提示", subTitle:"您的网络连接不稳定，请重新刷新。", closeButtonTitle:"知道了")
                return
            } else {
                let data = JSON_DATA
                self.universityIsFollowedData = data["university"]["isFollowed"].bool!
                self.universityNumOfFollowersData = data["university"]["numOfFollowers"].int!
                self.tableView.reloadData()
            }
        }
        
        let universityId = self.universityIdData
        
        let commentsURL = CommonURL.universityURL + "\(universityIdData)/posts"
        
        let parameters = [
            "id" : self.universityIdData,
            "token" : self.userToken,
            "startId" : offset,
            "resultSize" : 10
        ]
        
        // 请求数据
        Alamofire.request(.POST, commentsURL, parameters: parameters as? [String : AnyObject]).responseJSON { response in
            
            let JSON_DATA = JSON(data: response.data!)
            
            if JSON_DATA == nil{
                //SCLAlertView().showWarning("温馨提示", subTitle:"您的网络连接不稳定，请重新刷新。", closeButtonTitle:"知道了")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            } else {
                let data = JSON_DATA
                
                if offset == 0{
                    if !self.postsLoadingPageData.isEmpty{
                        self.postsLoadingPageData.removeAll(keepCapacity: false)
                    }
                }
                
                let postsArray = data["posts"].arrayValue
                self.userCommentData = data["posts"]
                //println(self.userCommentData)
                if postsArray.count > 0{
                    for postDataArray in postsArray{
                        let posts = postsLoadingData()
                        
                        posts.content = postDataArray["content"].string ?? ""
                        posts.userName = postDataArray["userName"].string ?? ""
                        posts.userLogo = postDataArray["userLogo"].string ?? ""
                        posts.creationDatetime = postDataArray["creationDatetime"].int!
                        posts.numOfLikes = postDataArray["numOfLikes"].int!
                        posts.pic1 = postDataArray["pic"][0].string ?? ""
                        ////                        posts.comments = postDataArray["role"].string ?? ""
                        posts.userId = postDataArray["userId"].int!
                        posts.isLike = postDataArray["isLiked"].bool!
                        posts.postId = postDataArray["postId"].int!
                        posts.numOfComments = postDataArray["numOfComments"].int!
                        self.postsLoadingPageData.append(posts)
                    }
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }}
        
    }
    /**************************************************************************************/
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    /**************************************************************************************/
    
    // MARK: 上拉加载数据
    func loadMoreData(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // 1.添加数据
        if self.userCommentData[9]["postId"].int == nil {
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
        } else {
            self.PAGE_NUM = self.userCommentData[9]["postId"].int!
            loadData(self.PAGE_NUM)
        }
        
        // 2.刷新表格
        // 拿到当前的上拉刷新控件，结束刷新状态
        let delayInSeconds:Int64 = 1000000000 * 2
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            
            self.tableView.reloadData()
            self.tableView.mj_footer.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    /**************************************************************************************/
    // MARK: 下拉刷新数据
    func loadNewData(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // 1.添加假数据
        self.PAGE_NUM = 0
        loadData(self.PAGE_NUM)
        
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        let delayInSeconds:Int64 = 1000000000 * 1
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            
            self.tableView.reloadData()
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.hidden = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }
    /**************************************************************************************/
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        return postsLoadingPageData.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }
        return tableView.rowHeight
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> groupCell_TableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("groupCell_TableViewCell") as! groupCell_TableViewCell
            cell.universityIdForButton = self.universityIdData
            cell.isFollowed = self.universityIsFollowedData
            if self.universityIsFollowedData {
                cell.followUniversityImage.image = UIImage(named: "following")
            }else{
                cell.followUniversityImage.image = UIImage(named: "follow")
            }
            //提取学校cover，background
            let profileData = CommonURL.universityCoverURL + self.universityCoverData
            Alamofire.request(.GET, profileData).response() {
                (_, _, data, _) in
                
                let image = UIImage(data: data!)
                cell.background.image = image
            }
            //提取国家国旗
            let encodedMessage = self.universitycountryData.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            
            let url = CommonURL.countryLogoURL + encodedMessage! + "Flag.png"
            Alamofire.request(.GET, url).response() {
                (_,_,data,_) in
                let image = UIImage(data: data!)
                cell.flag.image = image
            }
            
            //提取学校的logo
            let logoData = CommonURL.universityLogoURL + self.universityLogoData
            Alamofire.request(.GET, logoData).response() {
                (_, _, data, _) in
                
                let logoImage = UIImage(data: data!)
                cell.logo.image = logoImage
            }
            
            cell.memberNumber.text = String(self.universityNumOfFollowersData)
            cell.name.text = self.universityNameData
            cell.locaiton.text = self.universitycountryData
            cell.intro.text = self.universityDescriptionData
            cell.delegate = self
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentTableViewCell") as! commentTableViewCell
        
        let userInfo = postsLoadingPageData[indexPath.row]
        
        cell.userId = userInfo.userId
        cell.configureWithComments(userInfo)
        //按赞的uiaction，delegate给self
        cell.delegate = self
        
        return cell
        
        
    }
    
    // set the seprator to zero
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
    }
    
    
    // select the cell to segue, but when section == 0, there is no segue
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1{
            if self.comingFromFollowList == 0{
                self.performSegueWithIdentifier("commentDetail", sender: self)
            }else if self.comingFromFollowList == 1{
                self.performSegueWithIdentifier("commentDetail1", sender: self)
            }else{
                self.performSegueWithIdentifier("commentDetail2", sender: self)
            }
        }
        
    }
    
    // Passing data form segue "commentDetail"
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        if segue.identifier == "commentDetail"
//        {
//            if let destination = segue.destinationViewController as? commentsDetailTableViewController
//            {
//                if let blogIndex = tableView.indexPathForSelectedRow()?.row
//                {
//                    destination.comments = self.postsLoadingPageData[blogIndex]
//                }
//            }
//        }
//        if segue.identifier == "commentDetail1"
//        {
//            if let destination = segue.destinationViewController as? commentsDetail1TableViewController
//            {
//                if let blogIndex = tableView.indexPathForSelectedRow()?.row
//                {
//                    destination.comments = self.postsLoadingPageData[blogIndex]
//                }
//            }
//        }
//        if segue.identifier == "commentDetail2"
//        {
//            if let destination = segue.destinationViewController as? commentsDetail1TableViewController
//            {
//                if let blogIndex = tableView.indexPathForSelectedRow()?.row
//                {
//                    destination.comments = self.postsLoadingPageData[blogIndex]
//                }
//            }
//        }
    }
    
    
}