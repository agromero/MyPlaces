//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    var place:Place? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.constraintHeight.constant = 400
        // Do any additional setup after loading the view.
        
        if(place != nil){
            
            //Premen a la llista
            textName.text = place!.name
            textDescription.text = place!.description
        }
        else{
            
            // Es nou
            textName.text = ""
            textDescription.text = "New Place to be Added"
       }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
