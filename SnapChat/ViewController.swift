//
//  ViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 29/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    //sign in button event
    @IBAction func signin(_ sender: Any) {
        
        //trys to sign in the user using the email and password from the text feilds
        FIRAuth.auth()?.signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            print("sign in")
            //if there are errros signing the user in
            if error != nil{
                //print the error
                print("error \(error!)")
                //create a new user with the email and password from the text feilds data
                FIRAuth.auth()?.createUser(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                    //
                    print("create user")
                    //if there is any issues creating the user
                    if error != nil {
                        print("error \(error!)")
                        // the user is created and is logged in move to the next screen
                    }else{
                        //create user in db
                       FIRDatabase.database().reference().child("users").child(user!.uid).child("email").setValue(user!.email)
                        //go to next screen
                        self.performSegue(withIdentifier: "signedin", sender: nil)
                    }
                })
                // the user is logged in move to the next screen
            }else{
                self.performSegue(withIdentifier: "signedin", sender: nil)
            }
        })
    }

}

