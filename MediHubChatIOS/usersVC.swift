//
//  usersVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/5/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
var userName = ""

class usersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsUsernameArray = [String]()
    var resultsProfileNameArray = [String]()
    var resultsImageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRect(x:0, y:0,width: theHeight,height: theHeight-64)
        
        let messagesBarBtn = UIBarButtonItem(title: "Messages", style: UIBarButtonItem.Style.plain, target: self, action: #selector(messagesBtn_click))
        
        let groupBarBtn = UIBarButtonItem(title: "Group", style: UIBarButtonItem.Style.plain, target: self, action: #selector(groupBtn_click))
        
        let buttonArray = NSArray(objects: messagesBarBtn,groupBarBtn)
        self.navigationItem.rightBarButtonItems = buttonArray as? [UIBarButtonItem]
        
        //Lấy tên user hiện tại
        userName = PFUser.current()!.username!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func messagesBtn_click() {
        
        print("messages")
        
        self.performSegue(withIdentifier: "goToMessagesVC_FromUsersVC", sender: self)
        
    }
    
    @objc func groupBtn_click() {
        
        print("group")
        
        self.performSegue(withIdentifier: "goToGroupVC_FromUsersVC", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        resultsUsernameArray.removeAll(keepingCapacity: false)
        resultsProfileNameArray.removeAll(keepingCapacity: false)
        resultsImageFiles.removeAll(keepingCapacity: false)
        
        let predicate = NSPredicate(format: "username != '"+userName+"'")
        let query = PFQuery(className: "_User", predicate: predicate)
        let objects = try! query.findObjects()  //UPDATE THIS
        
        //let objects = objects! as [PFObject]
        for object in objects {  //UPDATE THIS
            
            let us:PFUser = object as! PFUser //UPDATE THIS ADD IT
            self.resultsUsernameArray.append(us.username!)   //UPDATE THIS
            self.resultsProfileNameArray.append(object["profileName"] as! String)
            self.resultsImageFiles.append(object["photo"] as! PFFile)
            
            self.resultsTable.reloadData()
            
            
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("OK...")
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! resultsCell
        
        otherName = cell.usernameLbl.text!
        otherProfileName = cell.profileNameLbl.text!
        self.performSegue(withIdentifier: "goToConversationVC", sender: self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsUsernameArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:resultsCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! resultsCell
        
        cell.usernameLbl.text = self.resultsUsernameArray[indexPath.row]
        cell.profileNameLbl.text = self.resultsProfileNameArray[indexPath.row]
        
        resultsImageFiles[indexPath.row].getDataInBackground(block: {
            (imageData: Data?, error:Error?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                cell.profileImg.image = image
                
            }
        })
        
        return cell
        
    }
    
    
    @IBAction func logoutBtn_click(sender: AnyObject) {
        
        PFUser.logOut()
        self.navigationController?.popToRootViewController(animated: true)
        
        
    }
    

}
