//
//  loginVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/4/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
class loginVC: UIViewController {
    
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var singupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func initUI(){
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        let theMid = theHeight/2
        let thePading = 50
        let heightItem = 30
        
        print("Frame:")
        print("\(view.frame.width) -- \(view.frame.height)")
        print("\(view.frame.size.width) -- \(view.frame.size.height)")
        print("\(view.frame.minX) -- \(view.frame.minY)")
        print("\(view.frame.maxX) -- \(view.frame.maxY)")
        print("\(view.frame.midX) -- \(view.frame.midY)")
        print("Bounds:")
        print("\(view.bounds.width) -- \(view.bounds.height)")
        print("\(view.bounds.size.width) -- \(view.bounds.size.height)")
        print("\(view.bounds.minX) -- \(view.bounds.minY)")
        print("\(view.bounds.maxX) -- \(view.bounds.maxY)")
        print("\(view.bounds.midX) -- \(view.bounds.midY)")
        
        //        welcomeLbl.center = CGPoint(x:theWidth/2,y: 130)
        //        usernameTxt.frame = CGRect(x:16, y:200,width: theWidth-32,height: 30)
        //        passwordTxt.frame = CGRect(x:16, y:240,width: theWidth-32,height: 30)
        //        loginBtn.center = CGPoint(x:theWidth/2,y: 330)
        //        singupBtn.center = CGPoint(x:theWidth/2,y: theHeight-30)
        
        
        welcomeLbl.center = CGPoint(x:theWidth/2,y: theMid-50-50)
        usernameTxt.frame = CGRect(x:16, y:theMid-50,width: theWidth-32,height: 30)
        passwordTxt.frame = CGRect(x:16, y:theMid,width: theWidth-32,height: 30)
        loginBtn.center = CGPoint(x:theWidth/2,y: theMid+100)
        singupBtn.center = CGPoint(x:theWidth/2,y: theMid+100+50)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Ẩn nút back
        self.navigationItem.hidesBackButton = true
        
      
        initUI()
        
    }
    
//    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        print("ok")
//        if UIDevice.current.orientation.isLandscape{
//            print("landscape")
//            initUI()
//        } else if UIDevice.current.orientation.isPortrait{
//           print("portrait")
//            initUI()
//        }
//    }
    @IBAction func loginClick(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!){ (user:PFUser?, logInError:Error?) -> Void in
            if logInError == nil {
                print("log in")
                let installation:PFInstallation = PFInstallation.current()!
                installation["user"] = PFUser.current()
                installation.saveInBackground(block: { (success:Bool, error:Error?) -> Void in
                    
                })
                self.performSegue(withIdentifier: "goToUsersVC", sender: self)
            } else {
                print("error log in")
            }
        }
    }

}
