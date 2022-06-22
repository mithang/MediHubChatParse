//
//  singupVC.swift
//  ChatApp
//
//  Created by Valsamis Elmaliotis on 11/4/14.
//  Copyright (c) 2014 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import Parse
class singupVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var addImgBtn: UIButton!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileNameTxt: UITextField!
    @IBOutlet weak var singupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        _ = view.frame.size.height
        
        profileImg.center = CGPoint(x:theWidth/2, y: 140)
        profileImg.layer.cornerRadius = profileImg.frame.size.width/2
        profileImg.clipsToBounds = true
        
        addImgBtn.center = CGPoint(x:self.profileImg.frame.maxX+50, y: 140)
        usernameTxt.frame = CGRect(x:16, y:230, width:theWidth-32,height: 30)
        passwordTxt.frame = CGRect(x:16,y: 270, width:theWidth-32, height:30)
        profileNameTxt.frame = CGRect(x:16,y: 310,width: theWidth-32,height: 30)
        singupBtn.center = CGPoint(x:theWidth/2, y:380)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addImageClick(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        profileImg.image = image
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        profileNameTxt.resignFirstResponder()
        return true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.main.bounds.height == 568) {
            
            if (textField == self.profileNameTxt) {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    
                    self.view.center = CGPoint(x:theWidth/2,y: (theHeight/2)-40)
                
                    }, completion: {
                        (finished:Bool) in
                        
                        //
                })
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        if (UIScreen.main.bounds.height == 568) {
            
            if (textField == self.profileNameTxt) {
                
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    
                    self.view.center = CGPoint(x:theWidth/2, y:(theHeight/2))
                    
                    }, completion: {
                        (finished:Bool) in
                        
                        //
                        
                })
            }
        }
    }
    @IBAction func signUpClick(_ sender: Any) {
        let user = PFUser()
        user.username = usernameTxt.text
        user.password = passwordTxt.text
        user.email = usernameTxt.text
        user["profileName"] = profileNameTxt.text
        
        let imageData = self.profileImg.image!.pngData()
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData!)
        user["photo"] = imageFile
        
        user.signUpInBackground(block: {
            (succeeded:Bool, signUpError:Error?) -> Void in
            if signUpError == nil {
                print("signup")
                let installation:PFInstallation = PFInstallation.current()!
                installation["user"] = PFUser.current()
                installation.saveInBackground(block: { (success:Bool, error:Error?) -> Void in
                })
                self.performSegue(withIdentifier: "goToUsersVC2", sender: self)
            } else {
                print("can't signup")
            }
        })
    }
    
    
}
