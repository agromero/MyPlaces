//
//  ManagerDisplay.swift
//  MyPlaces
//
//  Created by Agus on 22/11/2018.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import UIKit

let Grey1 = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
let Grey2 = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
// GREEN
/*
let darkColor1 = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)
let darkColor2 = UIColor(red: 0/255.0, green: 60/255.0, blue: 0/255.0, alpha: 1.0)
let darkColor3 = UIColor(red: 0/255.0, green: 40/255.0, blue: 0/255.0, alpha: 1.0)
*/

// PURPLE
let darkColor1 = UIColor(red: 45/255.0, green: 30/255.0, blue: 80/255.0, alpha: 1.0)
let darkColor2 = UIColor(red: 20/255.0, green: 10/255.0, blue: 50/255.0, alpha: 1.0)
let darkColor3 = UIColor(red: 60/255.0, green: 40/255.0, blue: 100/255.0, alpha: 1.0)



class ManagerDisplay : Codable {
    
    //******************************************
    // Singleton
    private static var sharedManagerDisplay: ManagerDisplay = {
        
    var singletonManager: ManagerDisplay?

        if (singletonManager == nil){
            singletonManager = ManagerDisplay()
        }
        return singletonManager!
        
    }()
    
    class func shared() -> ManagerDisplay {

        return sharedManagerDisplay
    }

    
    func ApplyRecursiveBackground(v:UIView)
    {
        
        
        if(((v as? UITextField) == nil) && ((v as? UITextView) == nil))
        {
            
            v.backgroundColor = darkColor1
            
            for subview in v.subviews {
                ApplyRecursiveBackground(v:subview)
            }
        }
    }
    
    
    func ApplyRecursiveButtonStyle(v:UIView)
    {
        
        for subview in v.subviews {
            
            if((subview as? UIButton) != nil)
            {
                subview.layer.cornerRadius = subview.frame.height / 2
                subview.backgroundColor = darkColor2
                subview.clipsToBounds = true
                subview.tintColor = UIColor.white
                subview.layer.borderColor = UIColor.white.cgColor
                subview.layer.borderWidth = 1
            }
            ApplyRecursiveButtonStyle(v:subview)
        }
    }

    
    func ApplyBackground(v:UIView){
        //Fondo de la vista
        v.backgroundColor = darkColor1
    }
    
    func ApplyNavigationBarStyle(vc:UIViewController){
        //Barra de navegación

        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.navigationBar.barStyle = .black
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationItem.rightBarButtonItem?.image = UIImage(named: "pinplus1")

        let logo = UIImage(named: "myplaces_logo")
        let imageView = UIImageView(frame: CGRect(x: 300, y: 0, width: 400, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        vc.navigationItem.titleView = imageView
        
        vc.tabBarController?.tabBar.barTintColor =  darkColor2
        vc.tabBarController?.tabBar.tintColor = .white
    
    }
    
   
    func ApplyCellDesign(cell: PlaceCell) {
        //Color Fondo de la celda
        cell.contentView.backgroundColor = darkColor2
        
        //Borde del thumbnail
        cell.placeImageView.layer.borderWidth = 2
        cell.placeImageView.layer.borderColor = UIColor.white.cgColor
        cell.placeImageView.layer.cornerRadius = 5.0
        
        //Colores del texto
        cell.placeTitleLabel.textColor = Grey1
        cell.placeSubtitleLabel.textColor = Grey2
        
        //Color al mantener pulsado
        let view = UIView()
        view.backgroundColor = darkColor3
        cell.selectedBackgroundView? = view
    }
   

}
