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

    override func viewDidLoad() {
        self.ApplyViewDesign()
        super.viewDidLoad()
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
        
        ApplyCellDesign(cell: celda!)
        
        return celda!
        
    }

  
    func onPlacesChange()
    {
        let view: UITableView = (self.view as? UITableView)!;
        view.reloadData()
    }
    
    
    private func ApplyViewDesign(){
        //Vamos a aplicar los cambios de diseño de la Vista desde el código
        
        let darkGreenColor = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)
        
        //Fondo de la vista
        view.backgroundColor = darkGreenColor
        
        //Barra de navegación
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = .white
        
        self.tableView.dequeueReusableCell(withIdentifier: "PlaceCell")?.contentView.backgroundColor = .red
        
    }
    
    private func ApplyCellDesign(cell: PlaceCell) -> UITableViewCell{
        //Vamos a aplicar los cambios de diseño de la celda desde el código
        
        //Color Fondo de la celda
        cell.contentView.backgroundColor = UIColor(red: 0/255.0, green: 40/255.0, blue: 0/255.0, alpha: 1.0)
        
        //Colores del texto
        cell.placeTitleLabel.textColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        cell.placeSubtitleLabel.textColor = UIColor(red: 150/255.0, green: 150/255.0, blue: 150/255.0, alpha: 1.0)
        
        //Color al mantener pulsado
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255.0, green: 60/255.0, blue: 0/255.0, alpha: 1.0)
        cell.selectedBackgroundView? = view
        
        return cell
    }
}

