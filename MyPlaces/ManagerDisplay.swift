//
//  ManagerDisplay.swift
//  MyPlaces
//
//  Created by Agus on 22/11/2018.
//  Copyright © 2018 user143154. All rights reserved.
//

import Foundation
import UIKit

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
        let darkGreenColor = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)
        
        //v.backgroundColor = UIColor(patternImage: UIImage(named: "carbon.jpg")!)
        v.backgroundColor = darkGreenColor
        
        for subview in v.subviews {
            
            ApplyRecursiveBackground(v:subview)
        }
        
    }
    
    
    func ApplyRecursiveButtonStyle(v:UIView)
    {
        let darkGreenColor2 = UIColor(red: 0/255.0, green: 60/255.0, blue: 0/255.0, alpha: 1.0)
        
        for subview in v.subviews {
            
            if((subview as? UIButton) != nil)
            {
                subview.layer.cornerRadius = subview.frame.height / 2
                subview.backgroundColor = darkGreenColor2
                subview.clipsToBounds = true
                subview.tintColor = UIColor.white
            }
            ApplyRecursiveButtonStyle(v:subview)
        }
        
    }

    
    func ApplyBackground(v:UIView){
        //Fondo de la vista
        let darkGreenColor = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)

        v.backgroundColor = darkGreenColor
    }
    
    func ApplyNavigationBarStyle(vc:UIViewController){
        //Barra de navegación
        vc.navigationController?.navigationBar.isTranslucent = true
        vc.navigationController?.navigationBar.barStyle = UIBarStyle.black
        vc.navigationController?.navigationBar.tintColor = .white
        vc.navigationItem.rightBarButtonItem?.image = UIImage(named: "pinplus1")
    }
    
    func ApplyCellDesign(cell: PlaceCell) {
        //Color Fondo de la celda
        cell.contentView.backgroundColor = UIColor(red: 0/255.0, green: 40/255.0, blue: 0/255.0, alpha: 1.0)
        
        //Borde del thumbnail
        cell.placeImageView.layer.borderWidth = 2
        cell.placeImageView.layer.borderColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        cell.placeImageView.layer.cornerRadius = 5.0
        
        //Colores del texto
        cell.placeTitleLabel.textColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.placeSubtitleLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
        
        //Color al mantener pulsado
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255.0, green: 60/255.0, blue: 0/255.0, alpha: 1.0)
        cell.selectedBackgroundView? = view
    }
    
    func ApplyDetailDesign(v: UIView) {
    }
    

}
