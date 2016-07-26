//
//  localStore.swift
//  Seahawks新的
//
//  Created by Tianming Miao on 5/11/15.
//  Copyright (c) 2015 Ownity Inc. All rights reserved.
//

import UIKit

class localStore {
    
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    //xmppaccountPrefix"dev_"
    static func saveXmppAccountPrefix(XmppAccountPrefix: String) {
        userDefaults.setObject(XmppAccountPrefix, forKey: "XmppAccountPrefix")
    }
    static func getXmppAccountPrefix() -> String? {
        return userDefaults.stringForKey("XmppAccountPrefix")
    }
    static func deletXmppAccountPrefix() {
        userDefaults.removeObjectForKey("XmppAccountPrefix")
    }
    //xmppserver_postfix"@chat.seahawks.com"
    
    static func saveXmppServer_postfix(server_postfix: String) {
        userDefaults.setObject(server_postfix, forKey: "server_postfix")
    }
    static func getXmppServer_postfix() -> String? {
        return userDefaults.stringForKey("server_postfix")
    }
    static func deletXmppServer_postfix() {
        userDefaults.removeObjectForKey("server_postfix")
    }
    //xmppUserId
    static func saveXmppUserId(userId: String) {
        userDefaults.setObject(userId, forKey: "XmppUserId")
    }
    static func getXmppUserId() -> String? {
        return userDefaults.stringForKey("XmppUserId")
    }
    static func deletXmppUserId() {
        userDefaults.removeObjectForKey("XmppUserId")
    }
    //xmppPassword
    static func saveXmppPassword(password: String) {
        userDefaults.setObject(password, forKey: "xmppPassword")
    }
    static func getXmppPassword() -> String? {
        return userDefaults.stringForKey("xmppPassword")
    }
    static func deletXmppPassword() {
        userDefaults.removeObjectForKey("xmppPassword")
    }
    //xmppServer
    static func saveXmppServer(server: String) {
        userDefaults.setObject(server, forKey: "xmppServer")
    }
    static func getXmppServer() -> String? {
        return userDefaults.stringForKey("xmppServer")
    }
    static func deletXmppServer() {
        userDefaults.removeObjectForKey("xmppServer")
    }
    //DeviceToken
    
    static func saveDeviceToken(deviceToken: String) {
        userDefaults.setObject(deviceToken, forKey: "deviceToken")
    }
    static func getDeviceToken() -> String? {
        return userDefaults.stringForKey("deviceToken")
    }
    static func deletDeviceToken() {
        userDefaults.removeObjectForKey("deviceToken")
    }
    //backUpDeviceToken
    
    static func saveBackUpDeviceToken(backUpDeviceToken: String) {
        userDefaults.setObject(backUpDeviceToken, forKey: "backUpDeviceToken")
    }
    static func getBackUpDeviceToken() -> String? {
        return userDefaults.stringForKey("backUpDeviceToken")
    }
    static func deletBackUpDeviceToken() {
        userDefaults.removeObjectForKey("backUpDeviceToken")
    }
    
    //RegisterNotification
    
    static func saveRegisterNotification(firstTime: Bool) {
        userDefaults.setObject(firstTime, forKey: "firstTime")
    }
    static func getRegisterNotification() -> Bool? {
        return userDefaults.boolForKey("firstTime")
    }
    static func deletRegisterNotification() {
        userDefaults.removeObjectForKey("firstTime")
    }
    
    // DisplayTimeLabel
    static func saveDisplayTimeLabel(token: String) {
        userDefaults.setObject(token, forKey: "DisplayTimeLabel")
    }
    
    static func getDisplayTimeLabel() -> String? {
        return userDefaults.stringForKey("DisplayTimeLabel")
    }
    
    static func deletDisplayTimeLabel() {
        userDefaults.removeObjectForKey("DisplayTimeLabel")
    }
    
    // Token
    static func saveToken(token: String) {
        userDefaults.setObject(token, forKey: "tokenKey")
    }
    
    static func getToken() -> String? {
        return userDefaults.stringForKey("tokenKey")
    }
    
    static func deleteToken() {
        userDefaults.removeObjectForKey("tokenKey")
    }
    //userLogo
    static func saveUserLogo(logo: String) {
        userDefaults.setObject(logo, forKey: "userLogo")
    }
    
    static func getUserLogo() -> String? {
        return userDefaults.stringForKey("userLogo")
    }
    
    static func deletUserLogo() {
        userDefaults.removeObjectForKey("userLogo")
    }
    //username
    static func saveusername(userName: String) {
        userDefaults.setObject(userName, forKey: "username")
    }
    
    static func getusername() -> String? {
        return userDefaults.stringForKey("username")
    }
    
    static func deleteusername() {
        userDefaults.removeObjectForKey("username")
    }
    // ISLOGGEDIN
    static func saveISLOGGEDIN(id: String) {
        userDefaults.setObject(id, forKey: "ISLOGGEDIN")
    }
    
    static func getISLOGGEDIN() -> String? {
        return userDefaults.stringForKey("ISLOGGEDIN")
    }
    
    static func deleteISLOGGEDIN() {
        userDefaults.removeObjectForKey("ISLOGGEDIN")
    }
    // ISPOSTLIKED
    static func savePostLike(token: String) {
        userDefaults.setObject(token, forKey: "ISPOSTLIKED")
    }
    
    static func getsavePostLike() -> String? {
        return userDefaults.stringForKey("ISPOSTLIKED")
    }
    
    static func deletgetsavePostLike() {
        userDefaults.removeObjectForKey("ISPOSTLIKED")
    }
    //userId
    static func saveuserId(token: Int) {
        userDefaults.setObject(token, forKey: "userId")
    }
    
    static func getuserId() -> Int? {
        return userDefaults.integerForKey("userId")
    }
    
    static func deleteuserId() {
        userDefaults.removeObjectForKey("userId")
    }
    //refreshForPost
    static func saverefreshForPost(token: String) {
        userDefaults.setObject(token, forKey: "saverefreshForPost")
    }
    
    static func getrefreshForPost() -> String? {
        return userDefaults.stringForKey("saverefreshForPost")
    }
    
    static func deletrefreshForPost() {
        userDefaults.removeObjectForKey("saverefreshForPost")
    }
    
    //savaLikedPosts
    static func saveLikePosts(postId: Int){
        userDefaults.setObject(postId, forKey: "postId\(postId)")
    }
    static func getSaveLikePosts(postId: Int) -> Int? {
        return userDefaults.integerForKey("postId\(postId)")
    }
    static func deleteLikePost(postId: Int) {
        userDefaults.removeObjectForKey("postId\(postId)")
    }
    
    
    //saveLikeProject
    static func saveLikeProject(projectId: Int){
        userDefaults.setObject(projectId, forKey: "LikeProjectId\(projectId)")
    }
    static func getLikeProject(projectId: Int) -> Int? {
        return userDefaults.integerForKey("LikeProjectId\(projectId)")
    }
    static func deletLikeProject(projectId: Int) {
        userDefaults.removeObjectForKey("LikeProjectId\(projectId)")
    }
    
    
    //saveFollowProject
    static func saveFollowProject(projectId: Int){
        userDefaults.setObject(projectId, forKey: "FollowProjectId\(projectId)")
    }
    static func getFollowProject(projectId: Int) -> Int? {
        return userDefaults.integerForKey("FollowProjectId\(projectId)")
    }
    static func deletFollowProject(projectId: Int) {
        userDefaults.removeObjectForKey("FollowProjectId\(projectId)")
    }
    //saveFollowedUniversity
    static func saveFollowedUniversity(universityId: Int){
        userDefaults.setObject(universityId, forKey: "universityId\(universityId)")
    }
    static func getSaveUniversityId(universityId: Int) -> Int? {
        return userDefaults.integerForKey("universityId\(universityId)")
    }
    static func deletSavedUniversity(universityId: Int) {
        userDefaults.removeObjectForKey("universityId\(universityId)")
    }
    //savePostNewPost
    static func savePostNewPost(id: Int){
        userDefaults.setObject(id, forKey: "NewpostId\(id)")
    }
    static func getPostNewPost(id: Int) -> Int? {
        return userDefaults.integerForKey("NewpostId\(id)")
    }
    static func deletPostNewPost(id: Int) {
        userDefaults.removeObjectForKey("NewpostId\(id)")
    }
    
    
    //saveLikedComments
    static func saveLikedComments(commentId: Int) {
        appendId(commentId, toKey: "likeCommentsKey")
    }
    
    static func isCommentUpvoted(commentId: Int) -> Bool {
        return arrayForKey("likeCommentsKey", containsId: commentId)
    }
    
    ////-- MARK: Helper
    private static func arrayForKey(key: String, containsId id: Int) -> Bool {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        return elements.contains(id)
    }
    
    private static func appendId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if !elements.contains(id) {
            userDefaults.setObject(elements + [id], forKey: key)
        }
    }
    
    private static func removeId(id: Int, toKey key: String) {
        let elements = userDefaults.arrayForKey(key) as? [Int] ?? []
        if elements.contains(id) {
            userDefaults.setObject(elements, forKey: key)
            //            userDefaults.removeObserver(elements + [id], forKeyPath: key)
            
        }
    }
    
    
}
