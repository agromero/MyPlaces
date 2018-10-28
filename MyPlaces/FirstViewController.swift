//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit


class FirstViewController: UITableViewController, ManagerPlacesObserver {
    
    let manager: ManagerPlaces = ManagerPlaces.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
        manager.addObserver(object: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Protocolo Tabla
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Número de elmentos del manager
        return manager.GetCount()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos
        // 1 porque no hay subsecciones.
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento.
        let place: Place = self.manager.GetItemAt(position: indexPath.row)
        
        let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        dc.place = place
        present(dc, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de la fila situada en una posición determinada.
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // devolver una instancia de la clase UITableViewCell que pinte la fila
        //seleccionada.
        let listItemType = ["Generic place", "Touristic place"]
      
        let celda = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell

        let item = manager.GetItemAt(position: indexPath.row)

        celda?.placeTitleLabel.text = item.name
        celda?.placeSubtitleLabel.text = listItemType[item.type.rawValue]
        celda?.placeImageView.image = UIImage(contentsOfFile: manager.GetPathImage(p:item))
        
        /* CODIGO ANTES DE IMPLEMENTAR LA CLASE CELDA PlaceCell
         let celda = UITableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.size.width, height: 100)))
         let item = manager.GetItemAt(position: indexPath.row)
         
         celda.textLabel?.text = item.name
         
         let imageIcon: UIImageView = UIImageView(image: UIImage(contentsOfFile: manager.GetPathImage(p:item)))
         imageIcon.frame = CGRect(x:0, y:0, width:60, height:45)
         celda.contentView.addSubview(imageIcon)
         
         */
        
        return celda!
        
    }

  
    func onPlacesChange()
    {
        let view: UITableView = (self.view as? UITableView)!;
        view.reloadData()
    }
    
}

