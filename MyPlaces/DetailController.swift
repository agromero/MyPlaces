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
       
        if(place != nil){
            
            //Mostrem un place
            viewPicker.delegate = self
            viewPicker.dataSource = self
            
            //Picker amb el valor sel.lecionat
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
            
            //Nom del Place
            textName.text = place!.name
            
            //Imatge: Temporalment afegim un border mentre no disposem d'imatges
            imagePicked.layer.borderWidth = 1
            //Descripció
            textDescription.text = place!.description
        }
        else{
            
            //Es un place Nou
            self.btnUpdate.setTitle("New", for: .normal)
            textName.text = ""
            textDescription.text = "New Place to be Added"
       }
        
        // Soft keyboard Control
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
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
     }
    

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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        view.endEditing(true)
        let image = info[UIImagePickerControllerOriginalImage] as!
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
                (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
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
