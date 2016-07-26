//
//  PostNewPostViewController.swift
//  Udrop
//
//  Created by Tianming Miao on 7/26/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import Alamofire
import SCLAlertView
import SwiftyJSON
import Foundation

class PostNewPostViewController: UIViewController, UITextViewDelegate {
    var id = 0
    //1 for university Reply,
    var sender = 0
    
    var university: JSON = []
    
    var toTextView = UITextView(frame: CGRect(x: 0,y: 70,width: UIScreen.mainScreen().bounds.width,height: UIScreen.mainScreen().bounds.height))
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewDidLoad() {
        
        self.id = NewPostId
        self.university = universityInfo
        self.sender = addCommentSender
        
        super.viewDidLoad()
        
        
        UINavigationBar.appearance().barTintColor = UIColor.colorWithHex("6D9EE1", alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        navigationItem.title = "留言评论"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .Plain, target: self, action: "cancelAction")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: "doneAction")
        navigationItem.rightBarButtonItem?.tintColor = UIColor.colorWithHex("#FFFFFF", alpha: 1)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.colorWithHex("#FFFFFF", alpha: 1)
        
        let positionY = self.navigationController?.navigationBar.frame.size.height
        
        self.view.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        self.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.colorWithHex("#6D9EE1", alpha: 1)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        toTextView.font = UIFont(name: "Helvetica Neue", size: 17)
        toTextView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)
        toTextView.placeholderText = "请输入你的想法..."
        
        self.view.addSubview(toTextView)
        
        
    }
    
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        //        println(textView.text)
    }
    
    // MARK: - Actions
    
    func cancelAction() {
        dismissViewControllerAnimated(true, completion: nil)
        //        println(self.university)
        //        println(self.id)
    }
    
    func doneAction()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if self.sender == 0
        {
            let postContent = self.toTextView.text
            if postContent.characters.count > 0
            {
                let postURL = CommonURL.universityURL + "\(self.id)/addPost"
                
                let parameters = [
                    "id" : self.id,
                    "token" : localStore.getToken()!,
                    "content" : postContent
                    //                "files" :
                ]
                Alamofire.request(.POST, postURL, parameters: parameters as? [String : AnyObject]).responseJSON
                    { response in
                        let JSON_DATA = JSON(data: response.data!)
                        
                        if JSON_DATA == nil
                        {
                            SCLAlertView().showWarning("温馨提示", subTitle:"您的网络连接不稳定，请重新刷新。", closeButtonTitle:"知道了")
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            return
                        } else
                        {
                            //这个地方需要缓存，然后再判断uniDetailTableViewController
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            localStore.savePostNewPost(self.id)
                            
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        }
                        
                }
            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }else
        {
            
            let universityId = self.university["universityId"].int!
            localStore.savePostNewPost(universityId)
            
            let postContent = self.toTextView.text
            if postContent.characters.count > 0
            {
                let postAddCommentURL = CommonURL.universityPostURL + "\(self.id)/addComment"
                let parameters = [
                    "id" : self.id,
                    "token" : localStore.getToken()!,
                    "content" : postContent
                    //                "files" :
                ]
                Alamofire.request(.POST, postAddCommentURL, parameters: parameters as? [String : AnyObject]).responseJSON
                    { response in
                        let JSON_DATA = JSON(data: response.data!)
                        
                        if JSON_DATA == nil
                        {
                            SCLAlertView().showWarning("温馨提示", subTitle:"您的网络连接不稳定，请重新刷新。", closeButtonTitle:"知道了")
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            return
                        } else
                        {
                            //这个地方需要缓存，然后再判断uniDetailTableViewController
                            self.dismissViewControllerAnimated(true, completion: nil)
                            
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        }
                        
                }
            }else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
        }
    }
    
}

extension UITextView: UITextViewDelegate {
    
    // Placeholder text
    var placeholderText: String? {
        
        get {
            // Get the placeholder text from the label
            var placeholderText: String?
            
            if let placeHolderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeHolderLabel.text
            }
            return placeholderText
        }
        
        set {
            // Store the placeholder text in the label
            var placeHolderLabel = self.viewWithTag(100) as! UILabel?
            if placeHolderLabel == nil {
                // Add placeholder label to text view
                self.addPlaceholderLabel(newValue!)
            }
            else {
                placeHolderLabel?.text = newValue
                placeHolderLabel?.sizeToFit()
            }
        }
    }
    
    // Hide the placeholder label if there is no text
    // in the text viewotherwise, show the label
    public func textViewDidChange(textView: UITextView) {
        
        var placeHolderLabel = self.viewWithTag(100)
        
        if !self.hasText() {
            // Get the placeholder label
            placeHolderLabel?.hidden = false
        }
        else {
            placeHolderLabel?.hidden = true
        }
    }
    
    // Add a placeholder label to the text view
    func addPlaceholderLabel(placeholderText: String) {
        
        // Create the label and set its properties
        var placeholderLabel = UILabel()
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin.x = 5.0
        placeholderLabel.frame.origin.y = 5.0
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGrayColor()
        placeholderLabel.tag = 100
        
        // Hide the label if there is text in the text view
        placeholderLabel.hidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.delegate = self;
    }
    
}
