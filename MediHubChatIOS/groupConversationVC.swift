//
//  groupConversationVC.swift
//  chatapp
//
//  Created by Valsamis Elmaliotis on 5/29/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
var groupConversationVC_title = ""

class groupConversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    var myImg:UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    let mLbl = UILabel(frame: CGRect(x:5,y: 10,width: 200,height: 20))
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3

    var messageArray = [String]()
    var senderArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsScrollView.frame = CGRect(x:0,y: 64,width: theWidth,height: theHeight-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRect(x:0, y:resultsScrollView.frame.maxY,width: theWidth,height: 50)
        lineLbl.frame = CGRect(x:0, y:0, width:theWidth, height:1)
        messageTextView.frame = CGRect(x:2, y:1,width: self.frameMessageView.frame.size.width-52, height:48)
        sendBtn.center = CGPoint(x:frameMessageView.frame.size.width-30, y: 24)
        
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        mLbl.text = "Type a message..."
        mLbl.backgroundColor = UIColor.clear
        mLbl.textColor = UIColor.lightGray
        messageTextView.addSubview(mLbl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        NotificationCenter.default.addObserver(self, selector: "getGroupMessageFunc", name: NSNotification.Name(rawValue: "getGroupMessage"), object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getGroupMessageFunc() {
        
        refreshResults()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.title = groupConversationVC_title
        
        let query = PFQuery(className: "_User")
        
        query.whereKey("username", equalTo: userName)
        
        let objects = try! query.findObjects()  //UPDATE THIS
        
        self.resultsImageFiles.removeAll(keepingCapacity: false)
        
        for object in objects { //UPDATE THIS
            
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsImageFiles[0].getDataInBackground(block:{
                (imageData:Data?, error:Error?) -> Void in
                
                if error == nil {
                    
                    self.myImg = UIImage(data: imageData!)
                    
                    self.refreshResults()
                    
                    
                }
                
            })
            
            
        }
        
    }
    
    func refreshResults() {
        
        let theWidth = view.frame.size.width
        //let theHeight = view.frame.size.height
        
        messageX = 37.0
        messageY = 26.0
        frameX = 32.0
        frameY = 21.0
        imgX = 3
        imgY = 3
        
        messageArray.removeAll(keepingCapacity: false)
        senderArray.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "GroupMessages")
        
        
        query.whereKey("group", equalTo: groupConversationVC_title)
        query.addAscendingOrder("createdAt")
        
        query.findObjectsInBackground(block: {
            (objects:[PFObject]?, error:Error?) -> Void in  //UPDATE THIS
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.object(forKey: "sender") as! String)
                    self.messageArray.append(object.object(forKey: "message") as! String)
                    
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                    
                }
                
                for i in 0...self.messageArray.count-1{
                    
                    if self.senderArray[i] == userName {
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRect(x:0,y: 0, width:self.resultsScrollView.frame.size.width-94, height:CGFloat.greatestFiniteMagnitude)
                        messageLbl.backgroundColor = UIColor.blue
                        messageLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.white
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.messageX) - messageLbl.frame.size.width
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        let frameLbl:UILabel = UILabel()
                        frameLbl.frame.size = CGSize(width:messageLbl.frame.size.width+10,height: messageLbl.frame.size.height+10)
                        frameLbl.frame.origin.x = (self.resultsScrollView.frame.size.width - self.frameX) - frameLbl.frame.size.width
                        frameLbl.frame.origin.y = self.frameY
                        frameLbl.backgroundColor = UIColor.blue
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        let img:UIImageView = UIImageView()
                        img.image = self.myImg
                        img.frame.size = CGSize(width:34,height: 34)
                        img.frame.origin.x = (self.resultsScrollView.frame.size.width - self.imgX) - img.frame.size.width
                        img.frame.origin.y = self.imgY
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSize(width:theWidth,height: self.messageY)
                        
                    } else {
                        
                        let messageLbl:UILabel = UILabel()
                        messageLbl.frame = CGRect(x:0,y: 0,width: self.resultsScrollView.frame.size.width-94,height: CGFloat.greatestFiniteMagnitude)
                        messageLbl.backgroundColor = UIColor.groupTableViewBackground
                        messageLbl.lineBreakMode = NSLineBreakMode.byWordWrapping
                        messageLbl.textAlignment = NSTextAlignment.left
                        messageLbl.numberOfLines = 0
                        messageLbl.font = UIFont(name: "Helvetica Neuse", size: 17)
                        messageLbl.textColor = UIColor.black
                        messageLbl.text = self.messageArray[i]
                        messageLbl.sizeToFit()
                        messageLbl.layer.zPosition = 20
                        messageLbl.frame.origin.x = self.messageX
                        messageLbl.frame.origin.y = self.messageY
                        self.resultsScrollView.addSubview(messageLbl)
                        self.messageY += messageLbl.frame.size.height + 30
                        
                        let frameLbl:UILabel = UILabel()
                        frameLbl.frame = CGRect(x:self.frameX,y: self.frameY,width: messageLbl.frame.size.width+10, height:messageLbl.frame.size.height+10)
                        frameLbl.backgroundColor = UIColor.groupTableViewBackground
                        frameLbl.layer.masksToBounds = true
                        frameLbl.layer.cornerRadius = 10
                        self.resultsScrollView.addSubview(frameLbl)
                        self.frameY += frameLbl.frame.size.height + 20
                        
                        let img:UIImageView = UIImageView()
                        
                        let query = PFQuery(className: "_User")
                        
                        query.whereKey("username", equalTo: self.senderArray[i])
                        let objects = try! query.findObjects()  //UPDATE THIS
                        
                        self.resultsImageFiles2.removeAll(keepingCapacity: false)
                        
                        for object in objects {  //UPDATE THIS
                            
                            self.resultsImageFiles2.append(object["photo"] as! PFFile)
                            
                            self.resultsImageFiles2[0].getDataInBackground(block:{
                                (imageData:Data?, error:Error?) -> Void in
                                
                                if error == nil {
                                    
                                    img.image = UIImage(data: imageData!)
                                    
                                }
                                
                            })
                            
                        }
                        
                        img.frame = CGRect(x:self.imgX,y: self.imgY,width: 34,height: 34)
                        img.layer.zPosition = 30
                        img.layer.cornerRadius = img.frame.size.width/2
                        img.clipsToBounds = true
                        self.resultsScrollView.addSubview(img)
                        self.imgY += frameLbl.frame.size.height + 20
                        
                        self.resultsScrollView.contentSize = CGSize(width:theWidth, height:self.messageY)
                        
                    }
                    
                    let bottomOffset:CGPoint = CGPoint(x:0, y:self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                    self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                    
                }
                
            }
            
            })

        
    }
    
    @objc func keyboardWasShown(notification:NSNotification) {
        
        let dict:NSDictionary = notification.userInfo! as NSDictionary
        let s:NSValue = dict.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let rect:CGRect = s.cgRectValue
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY - rect.height
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY - rect.height
            
            let bottomOffset:CGPoint = CGPoint(x:0, y:self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        //let dict:NSDictionary = notification.userInfo!
        //let s:NSValue = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        //let rect:CGRect = s.CGRectValue()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            
            self.resultsScrollView.frame.origin.y = self.scrollViewOriginalY
            self.frameMessageView.frame.origin.y = self.frameMessageOriginalY
            
            let bottomOffset:CGPoint = CGPoint(x:0,y: self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })
        
        
    }

    func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
    
        if !messageTextView.hasText {
    
            self.mLbl.isHidden = false
        } else {
    
            self.mLbl.isHidden = true
        }
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if !messageTextView.hasText {
            self.mLbl.isHidden = false
        }
    }

    @IBAction func sendBtn_click(sender: AnyObject) {
        
        if messageTextView.text == "" {
            
            print("no text")
            
            
        } else {
            
            let groupMessageTable = PFObject(className: "GroupMessages")
            
            groupMessageTable["group"] = groupConversationVC_title
            groupMessageTable["sender"] = userName
            groupMessageTable["message"] = self.messageTextView.text
            
            groupMessageTable.saveInBackground(block: {
                (success:Bool, error:Error?) -> Void in
                
                if success == true {
                    
                    var senderSet = Set([""])
                    senderSet.removeAll(keepingCapacity: false)
                    
                    for i in 0...self.senderArray.count-1{
                        
                        if self.senderArray[i] != userName {
                            
                            senderSet.insert(self.senderArray[i])
                            
                        }
                        
                    }
                    
                    let senderSetArray: NSArray = Array(senderSet) as NSArray
                    if senderSetArray.count>0{
                        for i2 in 0...senderSetArray.count - 1 {
                            
                            print(senderSetArray[i2])
                            
                            let uQuery:PFQuery = PFUser.query()!
                            uQuery.whereKey("username", equalTo: senderSetArray[i2])
                            
                            let pushQuery:PFQuery = PFInstallation.query()!
                            pushQuery.whereKey("user", matchesQuery: uQuery)
                            
                            let push:PFPush = PFPush()
                            push.setQuery(pushQuery as? PFQuery<PFInstallation>)
                            push.setMessage("New Group Message")
                            push.sendInBackground(block: {
                                (success:Bool, error:Error?) -> Void in
                                
                            })
                            print("push sent")
                            
                        }
                    }
                    
                    print("message sent")
                    
                    self.messageTextView.text = ""
                    self.mLbl.isHidden = false
                    self.refreshResults()
                    
                }
                
                })
            
        }
        
    }

}
