//
//  ViewController.swift
//  Instamoment
//
//  Created by Paul Chun on 2/25/15.
//  Copyright (c) 2015 Paul Chun. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var photoPreview: UIImageView!
    var photoSelected:Bool = false
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Photo taken")
        self.dismissViewControllerAnimated(true, completion: nil)
    
        photoPreview.image = image
        photoSelected = true
        
    }
    
    @IBAction func capturePhoto(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        //image.mediaTypes = [kUTTypeVideo]
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    @IBAction func postPhoto(sender: AnyObject) {
        var error = ""
        
        if (photoSelected == false) {
            
            error = "Please select an image to post"
            
        }
        
        if (error != "") {
            
            displayAlert("Cannot Post Image", error: error)
            
        } else {
            
            var photo = PFObject(className: "Photo")
            
            photo.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                
                if success == false {
                    
                    self.displayAlert("Could Not Post Image", error: "Please try again later")
                    
                } else {
                    
                    let imageData = UIImagePNGRepresentation(self.photoPreview.image)
                    
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    
                    photo["imageFile"] = imageFile
                    
                    photo.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                        
                        if success == false {
                            
                            self.displayAlert("Could Not Post Image", error: "Please try again later")
                            
                        } else {
                            
                            self.displayAlert("Image Posted!", error: "Your image has been posted successfully")
                            
                            self.photoSelected = false
                            
                            self.photoPreview.image = nil
                            
                            println("posted successfully")
                            
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Parse.setApplicationId("0l9XKr7frTt4FgHZ4NVyYdGq7cg4u20ZNh9vkohO", clientKey: "yp7FrPqZorKIPVcBSXnmfePYLtUEJh7ohKbakjW9")
        
        /*
        var photo = PFObject(className: "photo")
        photo.setObject("Untitled", forKey: "name")
        photo.setObject("asd", forKey: "url")
        photo.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            
            if (success == true) {
                println("Photo created with ID: \(photo.objectId)")
            } else {
                println(error)
            }
            
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

