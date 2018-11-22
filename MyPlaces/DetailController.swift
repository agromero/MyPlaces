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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!

    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!

    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    var place:Place? = nil
    var imgdata:Data? = nil

    // Places types
    let pickerElems1 = ["Generic place", "Touristic place"]
    let aplicaDisseny = 0 // 0 = Sense Disseny // 1 = Amb Disseny
    
    override func viewDidLoad() {
        
        
        let m_places_manager: ManagerPlaces = ManagerPlaces.shared()
        let m_display_manager: ManagerDisplay = ManagerDisplay.shared()

        super.viewDidLoad()
        // Do any additional setup after loading the view.

        m_display_manager.ApplyRecursiveBackground(v: self.view)
        m_display_manager.ApplyNavigationBarStyle(vc: self)
        m_display_manager.ApplyRecursiveButtonStyle(v: self.view)

        //Sempre mostrem el Picker
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        if(place != nil){
            //Quan és un place existent (UPDATE), mostrem:
            //Picker amb el valor sel.lecionat, el nom del place, la imatge i la descripció
            btnUpdate.setTitle("Update", for: .normal)
            btnUpdate.setTitle("Update", for: .highlighted)

            //Ocultem el botó SelectImage perquè no permetem canviar la imatge
            btnSelectImage.isHidden = true
            
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: false)
            textName.text = place!.name
            textDescription.text = place!.description
            imagePicked.image = UIImage(contentsOfFile: m_places_manager.GetPathImage(p: place!))
            
            if (imagePicked.image==nil){
            imagePicked.layer.borderWidth = 1  //Imatge: Temporalment afegim un border
            }

        }
        else{
            //Es un place Nou (NEW), mostrem els camps a omplir
            btnUpdate.setTitle("New", for: .normal)
            btnUpdate.setTitle("New", for: .highlighted)
            
            //Ocultem el botó Delete perquè no hem creat encara el Place
            btnDelete.isHidden = true

            textName.text = "Enter Title here"
            imagePicked.layer.borderWidth = 1  //Imatge: Temporalment afegim un border
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
    

    @IBAction func SelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    //Comportament del botó Update/New
    @IBAction func Update(_ sender: Any) {
        
        let m_places_manager: ManagerPlaces = ManagerPlaces.shared()
        let m_location_manager: ManagerLocation = ManagerLocation.shared()
        
        if(place != nil){
            
            //Actualizamos los campos editables permitidos
            
            place?.name = textName.text!
            place?.description = textDescription.text!
        }
        else
        {
            let selectedtype = viewPicker.selectedRow(inComponent: 0)
            let imgdata = imagePicked.image?.jpegData(compressionQuality: 0.75)
        
            switch selectedtype {
            case 0:
                //Generic Place
                let newplace = Place(name: textName.text!, description: textDescription.text!, image_in: imgdata)
                //newplace.location = ManagerLocation.GetLocation()
                newplace.location = m_location_manager.GetLocation()
                m_places_manager.append(newplace)
            case 1:
                //Touristic Place
                let newplace = PlaceTourist(name: textName.text!, description: textDescription.text!, discount_tourist: "10?", image_in: imgdata )
                //newplace.location = ManagerLocation.GetLocation()
                newplace.location = m_location_manager.GetLocation()
                m_places_manager.append(newplace)
            default:
                break
            }
        }
        
        m_places_manager.store()
        
        m_places_manager.UpdateObservers()
        
        dismiss(animated: true, completion: nil)
     }
    
    //Comportament del botó Delete
    @IBAction func Delete(_ sender: Any) {
        let m_places_manager: ManagerPlaces = ManagerPlaces.shared()
        
        if(place != nil){
                    m_places_manager.remove(place!)
        }

        m_places_manager.store()
        
        m_places_manager.UpdateObservers()
        
        dismiss(animated: true, completion: nil)
    }
    
    //Comportament del botó Cancel
    @IBAction func Cancel(_ sender: Any) {
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

    private func ApplyButtonDesign(){
        //Vamos a aplicar los cambios de diseño de la Vista desde el código
        
        let darkGreenColor = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)
        
        //Diseño Botón Update
        
        btnUpdate.backgroundColor = UIColor.clear
        btnUpdate.layer.borderWidth = 2
        btnUpdate.layer.borderColor = darkGreenColor.cgColor
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}


