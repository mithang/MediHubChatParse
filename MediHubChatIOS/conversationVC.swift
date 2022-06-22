//
//  conversationVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/6/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
var otherName = ""
var otherProfileName = ""

class conversationVC: UIViewController, UIScrollViewDelegate, UITextViewDelegate {

    @IBOutlet weak var resultsScrollView: UIScrollView!
    @IBOutlet weak var frameMessageView: UIView!
    @IBOutlet weak var lineLbl: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    //@IBOutlet weak var blockBtn: UIBarButtonItem!
    
    var scrollViewOriginalY:CGFloat = 0
    var frameMessageOriginalY:CGFloat = 0
    
    let mLbl = UILabel(frame: CGRect(x:5,y: 10,width: 200,height: 20))
    
    var messageX:CGFloat = 37.0
    var messageY:CGFloat = 26.0
    var frameX:CGFloat = 32.0
    var frameY:CGFloat = 21.0
    var imgX:CGFloat = 3
    var imgY:CGFloat = 3
    
    var messageArray = [String]()
    var senderArray = [String]()
    
    var myImg:UIImage? = UIImage()
    var otherImg:UIImage? = UIImage()
    
    var resultsImageFiles = [PFFile]()
    var resultsImageFiles2 = [PFFile]()
    
    var isBlocked = false
    
    var blockBtn = UIBarButtonItem()
    var reportBtn = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsScrollView.frame = CGRect(x:0, y:64,width: theWidth,height: theHeight-114)
        resultsScrollView.layer.zPosition = 20
        frameMessageView.frame = CGRect(x:0, y:resultsScrollView.frame.maxY,width: theWidth,height: 50)
        lineLbl.frame = CGRect(x:0, y:0,width: theWidth,height: 1)
        messageTextView.frame = CGRect(x:2,y: 1,width: self.frameMessageView.frame.size.width-52,height: 48)
        sendBtn.center = CGPoint(x:frameMessageView.frame.size.width-30, y:24)
        
        scrollViewOriginalY = self.resultsScrollView.frame.origin.y
        frameMessageOriginalY = self.frameMessageView.frame.origin.y
        
        self.title = otherProfileName
        
        mLbl.text = "Type a message..."
        mLbl.backgroundColor = UIColor.clear
        mLbl.textColor = UIColor.lightGray
        messageTextView.addSubview(mLbl)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapScrollView))
        tapScrollViewGesture.numberOfTapsRequired = 1
        resultsScrollView.addGestureRecognizer(tapScrollViewGesture)
        
        NotificationCenter.default.addObserver(self, selector: "getMessageFunc", name: NSNotification.Name(rawValue: "getMessage"), object: nil)
        
        blockBtn.title = ""
        
        blockBtn = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: Selector("blockBtn_click"))
        
        reportBtn = UIBarButtonItem(title: "Report", style: UIBarButtonItem.Style.plain, target: self, action: Selector("reportBtn_click"))
        
        let buttonArray = NSArray(objects: blockBtn,reportBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
    }
    
    func getMessageFunc() {
        
        refreshResults()
        
    }
    
    @objc func didTapScrollView() {
        
        self.view.endEditing(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        
        if !messageTextView.hasText {
            
            self.mLbl.isHidden = false
        } else {
            
            self.mLbl.isHidden = true
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if !messageTextView.hasText {
            self.mLbl.isHidden = false
        }
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
            
            let bottomOffset:CGPoint = CGPoint(x:0, y:self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
            self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
            
            }, completion: {
                (finished:Bool) in
                
        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let checkQuery = PFQuery(className: "Block")
        checkQuery.whereKey("user", equalTo: otherName)
        checkQuery.whereKey("blocked", equalTo: userName)
        let objects2 = try! checkQuery.findObjects() // UPDATE THIS
        
        if objects2.count > 0 { //UPDATE THIS
            
            isBlocked = true
        } else {
            
            isBlocked = false
        }
        
        let blockQuery = PFQuery(className: "Block")
        blockQuery.whereKey("user", equalTo: userName)
        blockQuery.whereKey("blocked", equalTo: otherName)
        let objects0 = try! blockQuery.findObjects()  // UPDATE THIS
        
        if objects0.count > 0 {   //UPDATE THIS
            self.blockBtn.title = "Unblock"
            
        } else {
            self.blockBtn.title = "Block"
            
        }
        
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: userName)
        let objects = try! query.findObjects()  //UPDATE THIS
        
        self.resultsImageFiles.removeAll(keepingCapacity: false)
        
        for object in objects {  //UPDATE THIS
            
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            

            
            self.resultsImageFiles[0].getDataInBackground ( block: { (imageData:Data?, error:Error?) -> Void in
                
                if error == nil {
                    
                    self.myImg = UIImage(data: imageData!)
                    
                    let query2 = PFQuery(className: "_User")
                    query2.whereKey("username", equalTo: otherName)
                    let objects2 = try! query2.findObjects()  //UPDATE THIS
                    
                    self.resultsImageFiles2.removeAll(keepingCapacity: false)
                    
                    for object in objects2 {   //UPDATE THIS
                        
                        self.resultsImageFiles2.append(object["photo"] as! PFFile)
                        
                        self.resultsImageFiles2[0].getDataInBackground {
                            (imageData:Data?, error:Error?) -> Void in
                            
                            
                            if error == nil {
                                
                                self.otherImg = UIImage(data: imageData!)
                                
                                self.refreshResults()
                                
                            }
            
                        }
                        
                    }
                    
                }
    
            } )

        }
        
        
    }
    
    //UPDATE
    func longPressed (longPressed: UIGestureRecognizer) {
        
        if (longPressed.state == UIGestureRecognizer.State.ended) {
            
            print("Ended")
            
        } else if (longPressed.state == UIGestureRecognizer.State.began) {
            
            print("Began")
            
            let lab:UILabel = longPressed.view as! UILabel
            let labTxt = lab.text!
            let labCol:UIColor = lab.backgroundColor!
            
            let alert:UIAlertController = UIAlertController(title: "Delete Message", message: "Do you want to delete the message?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: {
                (action) -> Void in
                
                print(labTxt)
                
                if labCol == UIColor.blue {
                    
                    print("blue")
                    
                    let query = PFQuery(className: "Messages")
                    
                    query.whereKey("sender", equalTo: userName)
                    query.whereKey("other", equalTo: otherName)
                    query.whereKey("message", equalTo: labTxt)
                    
                    let objects = try! query.findObjects()   //UPDATE THIS
                    
                    for object in objects {  //UPDATE THIS
                        
                        let ob:PFObject = object  //UPDATE THIS
                        
                        try! ob.delete() //UPDATE THIS
                        
                        self.refreshResults()
                        
                    }
                    
                } else {
                    
                    
                    print("no blue")
                    
                    let query = PFQuery(className: "Messages")
                    
                    query.whereKey("sender", equalTo: otherName)
                    query.whereKey("other", equalTo: userName)
                    query.whereKey("message", equalTo: labTxt)
                    
                    let objects = try! query.findObjects() //UPDATE THIS
                    
                    for object in objects {  //UPDATE THIS
                        
                        let ob:PFObject = object //UPDATE THIS
                        try! ob.delete()   //UPDATE THIS
                        
                        self.refreshResults()
                        
                    }
                    
                }
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
            }))
            
            self.present(alert, animated: true, completion: nil)

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
        
        let innerP1 = NSPredicate(format: "sender = %@ AND other = %@", userName, otherName)
        let innerQ1:PFQuery = PFQuery(className: "Messages", predicate: innerP1)
        
        let innerP2 = NSPredicate(format: "sender = %@ AND other = %@", otherName, userName)
        let innerQ2:PFQuery = PFQuery(className: "Messages", predicate: innerP2)
        
        let query = PFQuery.orQuery(withSubqueries: [innerQ1,innerQ2])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackground( block: { (objects:[PFObject]?, error:Error?) -> Void in  //UPDATE THIS
            
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.object(forKey: "sender") as! String)
                    self.messageArray.append(object.object(forKey: "message") as! String)
                    
                }
                
                for subView in self.resultsScrollView.subviews {
                    subView.removeFromSuperview()
                    
                }
                if self.messageArray.count>0{
                    for i in 0...self.messageArray.count-1 {
                        
                        if self.senderArray[i] == userName {
                            
                            let messageLbl:UILabel = UILabel()
                            messageLbl.frame = CGRect(x:0, y:0, width:self.resultsScrollView.frame.size.width-94,height: CGFloat.greatestFiniteMagnitude)
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
                            
                            //UPDATE
                            messageLbl.isUserInteractionEnabled = true
                            
                            let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
                            gesture.minimumPressDuration = 1.0
                            messageLbl.addGestureRecognizer(gesture)
                            //
                            
                            let frameLbl:UILabel = UILabel()
                            frameLbl.frame.size = CGSize(width:messageLbl.frame.size.width+10, height: messageLbl.frame.size.height+10)
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
                            
                            self.resultsScrollView.contentSize = CGSize(width:theWidth, height:self.messageY)
                            
                        } else {
                            
                            let messageLbl:UILabel = UILabel()
                            messageLbl.frame = CGRect(x:0, y:0, width:self.resultsScrollView.frame.size.width-94, height:CGFloat.greatestFiniteMagnitude)
                            messageLbl.backgroundColor = UIColor.groupTableViewBackground
                            messageLbl.lineBreakMode = .byWordWrapping
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
                            
                            //UPDATE
                            messageLbl.isUserInteractionEnabled = true
                            
                            let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
                            gesture.minimumPressDuration = 1.0
                            messageLbl.addGestureRecognizer(gesture)
                            //
                            
                            let frameLbl:UILabel = UILabel()
                            frameLbl.frame = CGRect(x:self.frameX,y: self.frameY,width: messageLbl.frame.size.width+10, height:messageLbl.frame.size.height+10)
                            frameLbl.backgroundColor = UIColor.groupTableViewBackground
                            frameLbl.layer.masksToBounds = true
                            frameLbl.layer.cornerRadius = 10
                            self.resultsScrollView.addSubview(frameLbl)
                            self.frameY += frameLbl.frame.size.height + 20
                            
                            let img:UIImageView = UIImageView()
                            img.image = self.otherImg
                            img.frame = CGRect(x:self.imgX,y: self.imgY,width: 34,height: 34)
                            img.layer.zPosition = 30
                            img.layer.cornerRadius = img.frame.size.width/2
                            img.clipsToBounds = true
                            self.resultsScrollView.addSubview(img)
                            self.imgY += frameLbl.frame.size.height + 20
                            
                            self.resultsScrollView.contentSize = CGSize(width:theWidth,height: self.messageY)
                            
                        }
                        
                        let bottomOffset:CGPoint = CGPoint(x:0,y: self.resultsScrollView.contentSize.height - self.resultsScrollView.bounds.size.height)
                        self.resultsScrollView.setContentOffset(bottomOffset, animated: false)
                        
                    }
                }
                
                
                
            }
   
            })
  
    }
    
    @IBAction func sendBtn_click(sender: AnyObject) {
        
        if isBlocked == true {
            
            print("you are blocked!!!!")
            return
            
        }
        
        if blockBtn.title == "Unblock" {
            
            print("you have blocked this user!!! unblock to send message")
            return
            
        }
        
        if messageTextView.text == "" {
            
            print("no text")
            
        } else {
            
            let messageDBTable = PFObject(className: "Messages")
            messageDBTable["sender"] = userName
            messageDBTable["other"] = otherName
            messageDBTable["message"] = self.messageTextView.text
            messageDBTable.saveInBackground( block: {
                (success:Bool, error:Error?) -> Void in
                
                if success == true {
                    
                    let uQuery:PFQuery = PFUser.query()!
                    uQuery.whereKey("username", equalTo: otherName)
                    
                    let pushQuery:PFQuery = PFInstallation.query()!
                    pushQuery.whereKey("user", matchesQuery: uQuery)
                    
                    let push:PFPush = PFPush()
                    push.setQuery(pushQuery as! PFQuery<PFInstallation>)
                    push.setMessage("New Message")
                    //push.sendPush()
                    
                    do {
                        try push.send()
                        
                    } catch {
                            
                    }
                    
                    print("push sent")
                    
                    print("meesage sent")
                    self.messageTextView.text = ""
                    self.mLbl.isHidden = false
                    self.refreshResults()
                    
                }
                
                })
            
        }
        
    }
    
    func blockBtn_click() {
        
        if blockBtn.title == "Block" {
            
            let addBlock = PFObject(className: "Block")
            addBlock.setObject(userName, forKey: "user")
            addBlock.setObject(otherName, forKey: "blocked")
            addBlock.saveInBackground(block: { (success:Bool, error:Error?) -> Void in
                
                })
            //addBlock.saveInBackground()
            self.blockBtn.title = "Unblock"
            
        } else {
            
            let query:PFQuery = PFQuery(className: "Block")
            query.whereKey("user", equalTo: userName)
            query.whereKey("blocked", equalTo: otherName)
            let objects = try! query.findObjects()  //UPDATE THIS
            
            for object in objects {  //UPDATE THIS
                
                try! object.delete() //UPDATE THIS
            }
            
            self.blockBtn.title = "Block"
            
            
        }
        
    }
    
    func reportBtn_click() {
        
        print("report pressed")
        
        let addReport = PFObject(className: "Report")
        addReport.setObject(userName, forKey: "user")
        addReport.setObject(otherName, forKey: "reported")
        addReport.saveInBackground(block: { (success:Bool, error:NSError?) -> Void in
            
            } as! PFBooleanResultBlock)

        //addReport.saveInBackground()
        
        print("report sent")
    }

}
