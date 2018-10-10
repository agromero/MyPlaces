//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
 
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    var place:Place? = nil
    
    // Places types
    let pickerElems1 = ["Generic place", "Touristic place"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPicker.delegate = self
        viewPicker.dataSource = self
	
        // Do any additional setup after loading the view.
        
        if(place != nil){
            
            //Premen a la llista
            textName.text = place!.name
            
            
            //Temporalment afegim un border a la imatge mentre no disposem d'imatges
            imagePicked.layer.borderWidth = 1
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
    
    
     @IBAction func Update(_ sender: Any) {
     }
     // MARK: - Navigation

     @IBAction func Delete(_ sender: Any) {
     }
     
     func numberOfComponents(in pickerView: UIPickerView) -> Int
     {
     return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
     {
     return pickerElems1.count
     }
     
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
     {
     return pickerElems1[row]
     }
    
    /*
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        
        pickerLabel.text = pickerElems1[row]
        
        if row == 0
        {
            pickerLabel.textColor = UIColor.black
            pickerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        else
        {
            pickerLabel.textColor = UIColor.gray
            pickerLabel.font = UIFont.boldSystemFont(ofSize: 14)
        }
        
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
     */ 
     /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
