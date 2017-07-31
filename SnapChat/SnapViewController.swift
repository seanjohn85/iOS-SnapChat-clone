//
//  SnapViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 30/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit

import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SnapViewController: UIViewController {
    
    
    
    var snap = Snap()
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var des: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let x  = URL(string: snap.imageUrl)

        des.text = snap.des
        img.sd_setImage(with: x)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("gone")
        FIRDatabase.database().reference().child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("snaps").child(snap.key).removeValue()
    }
    

}
