//
//  groupTableViewController.swift
//  Udrop
//
//  Created by Tianming Miao on 7/25/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import CoreData
import Foundation
import SwiftSpinner
import MJRefresh
import SwiftyJSON

extension String {
    
    func stringByAppendingPathComponent(path: String) -> String {
        
        let nsSt = self as NSString
        
        return nsSt.stringByAppendingPathComponent(path)
    }
}

var userDefaults = NSUserDefaults.standardUserDefaults()

class groupTableViewController: UITableViewController, UISearchBarDelegate,UISearchDisplayDelegate,
                                UITextViewDelegate, groupCell_TableViewCellDelegate {

    var passingJsonData: JSON! = []
    var pageParameter: JSON! = []
    var univeristyLoadingPageDta :[universityLoadingData] = []
    var postsInfoPageData :[postsLoadingData] = []
    var universityPostsPrepareData: JSON! = []
    
    //已登入
    var statusList = [xmppStatusStruct]()
    var logged = false
    var pageNum  = 1

    //Add searchController

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.navigationController?.navigationBar.barTintColor = UIColor.colorWithHex("#7BD4F9")
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //清空app badge number
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        if (localStore.getISLOGGEDIN() == "1") {
            self.login()
        }
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let isLoggedIn = prefs.integerForKey("ISLOGGEDIN")
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goBackToSignIn", sender: self)
        } else {
            let fileManager = NSFileManager.defaultManager()
            let myDirectory:String = NSHomeDirectory() + "/Documents/\(localStore.getuserId()!)Files"
            var error:NSErrorPointer = nil
            
            //withIntermediateDirectories为ture表示路径中间如果有不存在的文件夹都会创建
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(myDirectory, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                NSLog("\(error.localizedDescription)")
            }
            
            
            let filePath1 = (myDirectory as NSString).stringByAppendingPathComponent("universityList.plist")
            if (fileManager.fileExistsAtPath(filePath1)) {
                print("存在universityList")
                
                userDefaults.setBool(true, forKey: "universityListIsExist")
                
                let dataSource = NSArray(contentsOfFile: filePath1)
                
                var swiftArray = dataSource as! AnyObject as! [[String: AnyObject]]
                
                let count = swiftArray.count
                
                for i in 0 ..< count {
                    let university = universityLoadingData()
                    university.name = swiftArray[i]["name"]!.string ?? ""
                    university.country = swiftArray[i]["country"]!.string ?? ""
                    university.logo = swiftArray[i]["logo"]!.string ?? ""
                    university.cover = swiftArray[i]["cover"]!.string ?? ""
                    
                    self.univeristyLoadingPageDta.append(university)
                }
                
            }else{
                // Add Refresher
                /**************************************************************/

                self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadNewData))
                
                self.tableView.mj_header.beginRefreshing()
                
                self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadMoreData))
                self.tableView.mj_footer.hidden = true
                /**************************************************************/
                
            }
            
            
            self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadNewData))
            
            self.tableView.mj_header.beginRefreshing()
            
            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(groupTableViewController.loadMoreData))
            self.tableView.mj_footer.hidden = true            /**************************************************************/

        }
    }

    override func viewDidAppear(animated: Bool) {
        self.clearAllNotice()
        
        self.tableView.tableFooterView = UIView()
        
//        appDelegate().statusDelegate = self
//        
//        appDelegate().messageDelegate = self
        
        self.tableView.reloadData()
        
        let isLoggedIn = NSUserDefaults.standardUserDefaults().integerForKey("ISLOGGEDIN")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return univeristyLoadingPageDta.count
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        performSegueWithIdentifier("groupCellDetail", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> groupCell_TableViewCell {
        
        if userDefaults.boolForKey("universityListIsExist"){

           let cell = tableView.dequeueReusableCellWithIdentifier("groupCell_TableViewCell", forIndexPath: indexPath) as! groupCell_TableViewCell
            
            let myDirectory:String = NSHomeDirectory() + "/Documents/\(localStore.getuserId()!)Files"
            
            let filePath1 = (myDirectory as NSString).stringByAppendingPathComponent("universityList.plist")
            
            let dataSource = NSArray(contentsOfFile: filePath1)
            var swiftArray = dataSource as! AnyObject as! [[String: AnyObject]]
            
            let universityData = swiftArray[indexPath.row]
            cell.configureWithPlisData(universityData)
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell_TableViewCell", forIndexPath: indexPath) as! groupCell_TableViewCell
        
        let universityData = univeristyLoadingPageDta[indexPath.row]
        
        cell.configureWithCell(universityData)
        
        return cell
        
    }

    
    // Passing the data from Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupCellDetail" {
            //之前的版本对于data来说的
            if let destination = segue.destinationViewController as? group_cell_DetailTableViewController {
                
                if let blogIndex = tableView.indexPathForSelectedRow?.row{
                    
                    destination.university = passingJsonData[blogIndex]
                    
                    destination.isChecked = univeristyLoadingPageDta[blogIndex].isFollowed as Bool
                    
                    destination.universityNameData = univeristyLoadingPageDta[blogIndex].name as String
                    destination.universitycountryData = univeristyLoadingPageDta[blogIndex].country as String
                    destination.universityLogoData = univeristyLoadingPageDta[blogIndex].logo as String
                    destination.universityCoverData = univeristyLoadingPageDta[blogIndex].cover as String
                    destination.universityViewsData = univeristyLoadingPageDta[blogIndex].views as Int
                    destination.universityDescriptionData = univeristyLoadingPageDta[blogIndex].introduction as String
                    destination.universityNumOfFollowersData = univeristyLoadingPageDta[blogIndex].numOfFollowers as Int
                    destination.universityIsFollowedData = univeristyLoadingPageDta[blogIndex].isFollowed as Bool
                    destination.universityIdData = univeristyLoadingPageDta[blogIndex].universityId as Int
                    
                }
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    
    

//    func appDelegate() -> AppDelegate{
//        return UIApplication.sharedApplication().delegate as! AppDelegate
//    }
    //登录
    func login() {
        //清空unread和状态数组
        //        unreadList.removeAll(keepCapacity: false)
        //        statusList.removeAll(keepCapacity: false)
        
//        appDelegate().connect()
        self.logged = true
        self.tableView.reloadData()
    }
    
    func followButtonDidPressed(cell: groupCell_TableViewCell, sender: AnyObject) {
        
    }
    
    // MARK: 上拉加载数据
    func loadMoreData(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        // 1.添加数据
        let currentPage = self.pageParameter["page"].string!
        let totalPages = self.pageParameter["totalPages"].string!
        let numberOfCurrentPage = Int(currentPage)
        let numberOftotalPages = Int(totalPages)
        if numberOfCurrentPage >= numberOftotalPages {
            
            self.tableView.mj_footer.endRefreshingWithNoMoreData()
            
            let delayInSeconds:Int64 = 1000000000 * 1
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        } else{
            self.pageNum += 1
            loadData(self.pageNum)
            // 2.刷新表格
            // 拿到当前的上拉刷新控件，结束刷新状态
            let delayInSeconds:Int64 = 1000000000 * 1
            let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                
                self.tableView.reloadData()
                self.tableView.mj_footer.endRefreshing();
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        }
    }

    
    // MARK: 下拉刷新数据
    func loadNewData(){
        print("进入loadNewData")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // 1.添加假数据
        self.pageNum = 1
        loadData(self.pageNum)
        // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
        let delayInSeconds:Int64 = 1000000000 * 2
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
        dispatch_after(popTime, dispatch_get_main_queue(), {
            
            self.tableView.reloadData()
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.hidden = false
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            
        })
    }
    
    
    // MARK: 加载数据
    func loadData(offset:Int){
        //接口url
        
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "universityListIsExist")
        
        let univeristyURL = CommonURL.universityURL
        
        let parameters = [
            "page" : offset,
            "token" : localStore.getToken()!
        ]
        
        print("到了这里")
        print(localStore.getToken()!)
        // 请求数据
        Alamofire.request(.POST, univeristyURL, parameters : parameters as? [String : AnyObject]).responseJSON { response in
            let JSON_DATA = JSON(data: response.data!)
            
            if JSON_DATA == nil{
                SCLAlertView().showWarning("温馨提示", subTitle:"您的网络连接不稳定，请重新刷新。", closeButtonTitle:"知道了")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                return
            }else{
                
                if offset == 1 {
                    if !self.univeristyLoadingPageDta.isEmpty{
                        self.univeristyLoadingPageDta.removeAll(keepCapacity: false)
                    }
                }
                
                let data = JSON_DATA
                
                self.passingJsonData = data["universityList"]
                self.pageParameter = data["params"]
                let universityArray = data["universityList"].arrayValue
                if universityArray.count > 0{
                    
                    for currentUniversity in universityArray{
                        let university = universityLoadingData()
                        university.name = currentUniversity["name"].string ?? ""
                        university.country = currentUniversity["country"].string ?? ""
                        university.state = currentUniversity["state"].string ?? ""
                        university.city = currentUniversity["city"].string ?? ""
                        university.logo = currentUniversity["logo"].string ?? ""
                        university.cover = currentUniversity["cover"].string ?? ""
                        university.views = currentUniversity["views"].int!
                        university.universityId = currentUniversity["universityId"].int!
                        university.numOfFollowers = currentUniversity["numOfFollowers"].int!
                        university.isFollowed = currentUniversity["isFollowed"].bool!
                        university.introduction = currentUniversity["description"].string ?? ""
                        
                        self.univeristyLoadingPageDta.append(university)
                    }
                    
                    
                    let fileManager = NSFileManager.defaultManager()
                    let myDirectory:String = NSHomeDirectory() + "/Documents/\(localStore.getuserId()!)Files"
                    let filePath1 = (myDirectory as NSString).stringByAppendingPathComponent("universityList.plist")
                    
                    let dataSource = NSMutableArray()
                    
                    var swiftArray1 = dataSource as AnyObject as! [[String: AnyObject]]
                    
                    let count = self.univeristyLoadingPageDta.count
                    
                    for i in 0 ..< count {
                        let uuu:[String: AnyObject] = [
                            "name" : self.univeristyLoadingPageDta[i].name as String,
                            "country" : self.univeristyLoadingPageDta[i].country as String ,
                            "logo" : self.univeristyLoadingPageDta[i].logo as String ,
                            "cover" : self.univeristyLoadingPageDta[i].cover as String,
                            "isFollowed" : self.univeristyLoadingPageDta[i].isFollowed as Bool,
                            "numOfFollowers" : self.univeristyLoadingPageDta[i].numOfFollowers as Int,
                            "universityId" : self.univeristyLoadingPageDta[i].universityId as Int,
                            "views" : self.univeristyLoadingPageDta[i].views as Int,
                            
                        ]
                        swiftArray1.append(uuu)
                    }
                    
                    let savedNsarray = swiftArray1 as NSArray
                    savedNsarray.writeToFile(filePath1, atomically: true)
                    
                    
                }else{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                
                
            }
        }
        
    }


}
