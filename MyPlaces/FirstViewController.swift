//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143154 on 9/20/18.
//  Copyright © 2018 user143154. All rights reserved.
//

import UIKit


class FirstViewController: UITableViewController, ManagerPlacesObserver {
    
    let m_places_manager: ManagerPlaces = ManagerPlaces.shared()
    let m_location_manager: ManagerLocation = ManagerLocation.shared()
    let m_display_manager : ManagerDisplay = ManagerDisplay.shared()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        m_display_manager.ApplyBackground(v: self.view)
        m_display_manager.ApplyNavigationBarStyle(vc: self)
        
        let view: UITableView = (self.view as? UITableView)!;
        view.delegate = self
        view.dataSource = self
        m_places_manager.addObserver(object: self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    //Protocolo Tabla
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Número de elmentos del manager
        return m_places_manager.GetCount()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos 1 porque no hay subsecciones.
        return 1;
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento.
        let place: Place = self.m_places_manager.GetItemAt(position: indexPath.row)
        
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
        
        let item = m_places_manager.GetItemAt(position: indexPath.row)

        celda?.placeTitleLabel.text = item.name
        celda?.placeSubtitleLabel.text = listItemType[item.type.rawValue]
        celda?.placeImageView.image = UIImage(contentsOfFile: m_places_manager.GetPathImage(p:item))
        
        //El diseño de celda se utiliza unicamente en esta vista
        //pero está definido en la clase ManagerDisplay para unificar los temas de diseño
        m_display_manager.ApplyCellDesign(cell: celda!)
        
        return celda!
        
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let item = self.m_places_manager.GetItemAt(position: indexPath.row)
        
        let deleteButton = UITableViewRowAction(style: .default, title: "DELETE") { (action, indexPath) in
            
            self.m_places_manager.remove(item)
            
            self.m_places_manager.store()
            self.m_places_manager.UpdateObservers()
        }
        deleteButton.backgroundColor = .red

        //Este boton Edit lo ponemos para mostrar como añadir más opciones en el swipe
        let editButton = UITableViewRowAction(style: .default, title: "EDIT") { (action, indexPath) in
            
            let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
            dc.place = item
            self.present(dc, animated: true, completion: nil)
        }
        editButton.backgroundColor = .lightGray

        return [deleteButton, editButton] //Los botones se devuelven a la inversa de como se muestran
    }

    func onPlacesChange()
    {
        let view: UITableView = (self.view as? UITableView)!;
        view.reloadData()
    }

}

