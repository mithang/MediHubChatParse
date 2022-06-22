//
//  groupVC.swift
//  chatapp
//
//  Created by Valsamis Elmaliotis on 5/27/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
class groupVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var resultsTable: UITableView!
    
    var resultsNameArray = Set([""])
    var resultsNameArray2 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRect(x:0, y:0,width: theWidth,height: theHeight - 64)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        groupConversationVC_title = ""
        
        self.resultsNameArray.removeAll(keepingCapacity: false)
        self.resultsNameArray2.removeAll(keepingCapacity: false)
        
        let query = PFQuery(className: "GroupMessages")
        query.addAscendingOrder("group")
        
        
        query.findObjectsInBackground (block: { (objects:[PFObject]?, error:Error?) -> Void in //UPDATE THIS
            
            if error == nil {
                
                for object in objects! {
                    
                    self.resultsNameArray.insert(object.object(forKey: "group") as! String)
                    self.resultsNameArray2 = Array(self.resultsNameArray)
                    
                    self.resultsTable.reloadData()
                    
                }
                
                
            }
        } )
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray2.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:groupCell = tableView.dequeueReusableCell(withIdentifier: "groupCell") as! groupCell
        
        cell.groupNameLbl.text = resultsNameArray2[indexPath.row]
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 40
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        _ = tableView.cellForRow(at: indexPath as IndexPath) as! groupCell
        
        groupConversationVC_title = resultsNameArray2[indexPath.row]
        
        self.performSegue(withIdentifier: "goToGroupConversationVC_FromGroupVC", sender: self)
        
    }

    @IBAction func addGroupBtn_click(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Group", message: "Type the name of the group", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { (textField) -> Void in
            
        }
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) -> Void in
            
            print("ok pressed")
            
            let textF = alert.textFields![0] 
            
            let groupMessageObj = PFObject(className: "GroupMessages")
            
            let theUser:String = PFUser.current()!.username!
            
            groupMessageObj["sender"] = theUser
            groupMessageObj["message"] = "\(theUser) created a new Group"
            groupMessageObj["group"] = textF.text
            
            try! groupMessageObj.save()  //UPDATE THIS
            
            print("group created")
            
            groupConversationVC_title = textF.text!
            
            self.performSegue(withIdentifier: "goToGroupConversationVC_FromGroupVC", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {
            (action) -> Void in
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
