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
    let aplicaDisseny = 0 // 0 = Sense Disseny // 1 = Amb Disseny

    override func viewDidLoad() {

        if aplicaDisseny==1{
            self.ApplyViewDesign()
            self.ApplyBarButton()
        }

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
        
        if (aplicaDisseny==1){
            ApplyCellDesign(cell: celda!)
        }
        
        return celda!
        
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let item = m_places_manager.GetItemAt(position: indexPath.row)
            m_places_manager.remove(item)
            
            m_places_manager.store()
            m_places_manager.UpdateObservers()
            }
    }
/*
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {

        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            print("Delete button tapped")
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("Edit button tapped")
        }
        edit.backgroundColor = .lightGray
        
        return [delete, edit] //Buttons will appear in reverse order
    }
 */
    func onPlacesChange()
    {
        let view: UITableView = (self.view as? UITableView)!;
        view.reloadData()
    }
    
    
    func ApplyViewDesign(){
        //Vamos a aplicar los cambios de diseño de la Vista desde el código
        
        let darkGreenColor = UIColor(red: 0/255.0, green: 90/255.0, blue: 0/255.0, alpha: 1.0)
        
        //Fondo de la vista
        view.backgroundColor = darkGreenColor
        
        //Barra de navegación
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func ApplyCellDesign(cell: PlaceCell) -> UITableViewCell{
        //Vamos a aplicar los cambios de diseño de la celda desde el código

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
        
        return cell
    }
    
    private func ApplyBarButton(){
        let img = UIImage(named: "pinplus1")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let rightBarButtonItem = UIBarButtonItem(image: img, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

