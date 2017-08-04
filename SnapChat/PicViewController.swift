//
//  PicViewController.swift
//  SnapChat
//
//  Created by JOHN KENNY on 29/07/2017.
//  Copyright © 2017 JOHN KENNY. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class PicViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //image name
    var uuID = NSUUID().uuidString

    //UI outlets
    @IBOutlet var des: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var nextbtn: UIButton!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextbtn.isEnabled = false
        picker.delegate = self
    }

    
    @IBAction func camera(_ sender: Any) {
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func next(_ sender: Any) {
        
        nextbtn.isEnabled = false
        
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 0.1)!
        
        
        
        let folder =  FIRStorage.storage().reference().child("images")
        folder.child("\(uuID).jpg").put(imageData, metadata: nil) { (metaData, error) in
            //
            if error != nil{
                print("error upload \(error)")
            }else{
                print("URL \(metaData?.downloadURL())")
                
                self.performSegue(withIdentifier: "selectUser", sender: metaData?.downloadURL()?.absoluteString)
            }
        }
        
    }
    
    //pas to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
    
        let nextVC = segue.destination as! UserViewController
        nextVC.imageUrl = sender as! String
        nextVC.descr = des.text!
        nextVC.UUID = uuID
        
    
    }
    
    
    //select image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = img
        imageView.backgroundColor = UIColor.clear
        nextbtn.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }

}
