//
//  ViewController.swift
//  Udrop
//
//  Created by Tianming miao on 7/25/16.
//  Copyright © 2016 TianmingMiao. All rights reserved.
//

import UIKit
import QuartzCore
import SCLAlertView
import Alamofire
import SwiftSpinner
import SwiftyJSON

var loginState:Bool  = false

class LogInViewController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var loginCode: Int?
    
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()

        self.loginButton.enabled = false
        
        EmailField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        
        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clearoutTextField(sender: AnyObject) {
        //clear out the warning label and boarder color
        self.EmailField.layer.cornerRadius = 8.0
        self.EmailField.layer.masksToBounds = true
        self.EmailField.layer.borderColor = UIColor.clearColor().CGColor
        self.EmailField.layer.borderWidth = 2.0
        self.passwordField.layer.cornerRadius = 8.0
        self.passwordField.layer.masksToBounds = true
        self.passwordField.layer.borderColor = UIColor.clearColor().CGColor
        self.passwordField.layer.borderWidth = 2.0
        self.warningLabel.textColor = UIColor.clearColor()
    }

    @IBAction func editPasswordOrEmailPressed(sender: AnyObject) {
        EmailField.textColor = UIColor.darkGrayColor()
        passwordField.textColor = UIColor.darkGrayColor()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
//检查登录的用户是否有正确的账户和密码
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let username:NSString = EmailField.text!
        let password:NSString = passwordField.text!
        
        let parameters = [
            "email": username,
            "password": password,
            "rememberMe": true
        ]
        
        Alamofire.request(.POST, CommonURL.loginURL, parameters: parameters).responseJSON { response in
            let data = JSON(data: response.data!)
          
            let statusCode = data["statusCode"].int!
            if(statusCode == 0){
                
                let token = data["token"].string!
                //println(statusCode)
                let userId = data["user"]["userId"].int!
                let userLogo = data["user"]["logo"].string!
                let userName = data["user"]["username"].string!
                
                //token存入本地缓存
                localStore.saveToken(token)
                localStore.saveISLOGGEDIN("1")
                localStore.saveuserId(userId)
                localStore.saveUserLogo(userLogo)
                localStore.saveusername(userName)
                localStore.saveRegisterNotification(true)
                
                self.disablesAutomaticKeyboardDismissal()
                /***********************************************************************************/
                loginState = true
                
                let logoImageData = CommonURL.userLogoURL + userLogo
                Alamofire.request(.GET, logoImageData).response() {
                    (_, _, data, _) in
                    
                    let img = UIImage(data: data! )
                    
                    let smallImg = self.scaleFromImage(img!, size: CGSize(width: img!.size.width * 0.6, height: img!.size.height * 0.6))
                    let pathExtension = "png"
                    
                    let currentFileName = "\(userId).\(pathExtension)"
                    let imageData = UIImagePNGRepresentation(smallImg)
                    var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
                    let documentsDirectory : AnyObject = paths[0]
                    let fullPathToFile = documentsDirectory.stringByAppendingPathComponent(currentFileName)
                    
                    imageData!.writeToFile(fullPathToFile, atomically: false)
                }
                
                self.performSegueWithIdentifier("loginSegue", sender: self)
                
            } else if (statusCode == 1) {
                self.EmailField.layer.cornerRadius = 8.0
                self.EmailField.layer.masksToBounds = true
                self.EmailField.layer.borderColor = UIColor.colorWithHex("#FF6666",
                    alpha: 1).CGColor
                self.EmailField.layer.borderWidth = 2.0
                self.warningLabel.textColor = UIColor.colorWithHex("#FF6666",
                    alpha: 1)
                self.warningLabel.text = "Account does not exist!"
                
            } else if (statusCode == 2) {
                self.passwordField.layer.cornerRadius = 8.0
                self.passwordField.layer.masksToBounds = true
                self.passwordField.layer.borderColor = UIColor.colorWithHex("#FF6666",
                    alpha: 1).CGColor
                self.passwordField.layer.borderWidth = 2.0
                self.warningLabel.textColor = UIColor.colorWithHex("#FF6666",
                    alpha: 1)
                self.warningLabel.text = "Password is wrong!"
            } else {
                self.warningLabel.text = "Sign up problem!"
            }
        }
    }
    @IBAction func forgetPasswordPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("forgetPasswordSegue", sender: self)
    }
    
    
    //press Return to go to next TextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == EmailField) {
            EmailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
        }
        return true
    }

    func textFieldDidChange() {
        if (EmailField.text!.isEmpty || passwordField.text!.isEmpty) {
            self.loginButton(false)
        } else {
            self.loginButton(true)
        }
    }
    //Justify the size of Picture
    func scaleFromImage(image:UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func loginButton(enabled: Bool) -> () {
        func enable(){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginButton.setTitleColor(UIColor.colorWithHex("#7BD4F9",
                    alpha: 1), forState: UIControlState.Normal)
                }, completion: nil)
            
            loginButton.enabled = true
        }
        
        
        func disable(){
            loginButton.enabled = false
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.loginButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
                
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }

    
}

//Extension for Color to take Hex Values
extension UIColor{
    
    class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
        var rgb: CUnsignedInt = 0;
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

