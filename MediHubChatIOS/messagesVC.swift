//
//  messagesVC.swift
//  chatapp
//
//  Created by Valsamis Elmaliotis on 2/4/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
class messagesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    var senderArray = [String]()
    var otherArray = [String]()
    var messageArray = [String]()
    
    var sender2Array = [String]()
    var other2Array = [String]()
    var message2Array = [String]()
    
    var sender3Array = [String]()
    var other3Array = [String]()
    var message3Array = [String]()
    
    var results = 0
    var currResult = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRect(x:0, y:0,width: theWidth,height: theHeight - 64)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        resultsNameArray.removeAll(keepingCapacity: false)
        resultsImageFiles.removeAll(keepingCapacity: false)
        
        senderArray.removeAll(keepingCapacity: false)
        otherArray.removeAll(keepingCapacity: false)
        messageArray.removeAll(keepingCapacity: false)
        
        sender2Array.removeAll(keepingCapacity: false)
        other2Array.removeAll(keepingCapacity: false)
        message2Array.removeAll(keepingCapacity: false)
        
        sender3Array.removeAll(keepingCapacity: false)
        other3Array.removeAll(keepingCapacity: false)
        message3Array.removeAll(keepingCapacity: false)
    
        
        let setPredicate = NSPredicate(format: "sender = %@ OR other = %@", userName, userName)
        let query = PFQuery(className: "Messages", predicate: setPredicate)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackground (block: {
            (objects:[PFObject]?, error:Error?) -> Void in //UPDATE THIS
        
            if error == nil {
                
                for object in objects! {
                    
                    self.senderArray.append(object.object(forKey: "sender") as! String)
                    self.otherArray.append(object.object(forKey: "other") as! String)
                    self.messageArray.append(object.object(forKey: "message") as! String)
                    
                }
                if self.senderArray.count>0{
                    for i in 0 ... self.senderArray.count - 1 {
                        
                        if self.senderArray[i] == userName {
                            
                            self.other2Array.append(self.otherArray[i])
                        } else {
                            
                            self.other2Array.append(self.senderArray[i])
                        }
                        
                        self.message2Array.append(self.messageArray[i])
                        self.sender2Array.append(self.senderArray[i])
                    }
                }
                if self.other2Array.count>0{
                    for i2 in 0 ... self.other2Array.count - 1{
                        
                        var isfound = false
                        
                        for i3 in 0 ... self.other3Array.count - 1 {
                            
                            if self.other3Array[i3] == self.other2Array[i2] {
                                
                                isfound = true
                            }
                            
                        }
                        
                        if isfound == false {
                            
                            self.other3Array.append(self.other2Array[i2])
                            self.message3Array.append(self.message2Array[i2])
                            self.sender3Array.append(self.sender2Array[i2])
                            
                        }
                        
                    }
                }
                self.results = self.other3Array.count
                self.currResult = 0
                self.fetchResults()
                
            } else {
                
                //
                
            }
        
        
        })
        
        
    }
    
    func fetchResults() {
        
        if currResult < results {
            
            let queryF = PFUser.query()
            queryF!.whereKey("username", equalTo: self.other3Array[currResult])
            
            let objects = try! queryF!.findObjects()  //UPDATE THIS
            
            for object in objects {   //UPDATE THIS
                
                self.resultsNameArray.append(object.object(forKey: "profileName") as! String)
                self.resultsImageFiles.append(object.object(forKey: "photo") as! PFFile)
                
                self.currResult = self.currResult + 1
                self.fetchResults()
                
                self.resultsTable.reloadData()
                
            }
            
            
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsNameArray.count
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:messageCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! messageCell
        
        cell.nameLbl.text = self.resultsNameArray[indexPath.row]
        cell.messageLbl.text = self.message3Array[indexPath.row]
        cell.usernameLbl.text = self.other3Array[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackground (block: {
            (imageData : Data? , error : Error?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImageView.image = image
                
            }
            
        })
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! messageCell
        
        otherName = cell.usernameLbl.text!
        otherProfileName = cell.nameLbl.text!
        self.performSegue(withIdentifier: "goToConversationVC2", sender: self)
        

        
    }
    
}
