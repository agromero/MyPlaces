//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit

class DetailController: UIViewController,UITextViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    @IBOutlet weak var btnUpdate: UIButton!

    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    var place:Place? = nil

    // Places types
    let pickerElems1 = ["Generic place", "Touristic place"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        //Sempre mostrem el Picker
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        if(place != nil){
            //Quan és un place existent (UPDATE), mostrem:
            //Picker amb el valor sel.lecionat, el nom del place, la imatge i la descripció

            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
            textName.text = place!.name
            imagePicked.layer.borderWidth = 1  //Imatge: Temporalment afegim un border
            textDescription.text = place!.description
        }
        else{
            //Es un place Nou (NEW), mostrem els camps a omplir
            var imgdata:Data? = nil

            self.btnUpdate.setTitle("New", for: .normal)
            

            textName.text = "Enter Title here"
            imgdata = imagePicked.image?.jpegData(compressionQuality: 0.75)
            textDescription.text = "Enter Description here"
       }
        
        // Soft keyboard Control
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        textName.delegate = self
        textDescription.delegate = self    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func SelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        //imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func Update(_ sender: Any) {
        
        let manager = ManagerPlaces.shared

        //place?.location = ManagerLocation.GetLocation(place)

        if(place != nil){
            place?.name = textName.text!
            place?.description = textDescription.text!
        }
        else
        {
            let selectedtype = Place.PlacesTypes(rawValue: viewPicker.selectedRow(inComponent: 0))
            
            let newplace = Place(type: selectedtype!, name: textName.text!, description: textDescription.text!, image_in: nil)
            
            manager.append(newplace)
        }
        manager.UpdateObservers()
        dismiss(animated: true, completion: nil)
     }
    

    @IBAction func Delete(_ sender: Any) {
        let manager: ManagerPlaces = ManagerPlaces.shared

        manager.remove(place!)
        manager.UpdateObservers()
        dismiss(animated: true, completion: nil)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
// Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        view.endEditing(true)
        let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as!
        UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker:
        UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textViewShouldEndEditing(_ textView: UITextView) -> Bool
    {
        if(activeField==textView) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        if(activeField==textField) {
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    @objc func showKeyboard(notification: Notification) {
        if(activeField != nil){
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame =
                (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame =
                view.convert(keyboardScreenEndFrame, from: view.window)
            keyboardHeight = keyboardViewEndFrame.size.height
            let distanceToBottom = self.scrollView.frame.size.height -
                (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace > 0 {
                self.scrollView.setContentOffset(CGPoint(x:
                    self.lastOffset.x, y: collapseSpace + 10), animated: false)
                self.constraintHeight.constant += self.keyboardHeight
            }
            else{
                keyboardHeight = nil
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func hideKeyboard(notification: Notification) {
        if(keyboardHeight != nil){
            self.scrollView.contentOffset = CGPoint(x:
                self.lastOffset.x, y: self.lastOffset.y)
            self.constraintHeight.constant -= self.keyboardHeight
        }
        keyboardHeight = nil
    }
    
     /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
