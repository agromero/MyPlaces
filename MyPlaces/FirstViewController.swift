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
        // Do any additional setup after loading the view, typically from a nib.
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
        return 100
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // devolver una instancia de la clase UITableViewCell que pinte la fila
        //seleccionada.
        
        let celda = UITableViewCell(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.size.width, height: 100)))
      
        celda.textLabel?.text = manager.GetItemAt(position: indexPath.row).name
      
        return celda
        
    }
  
    func onPlacesChange()
    {
        let view: UITableView = (self.view as? UITableView)!;
        view.reloadData()
    }
    
    //NSDictionary *item = (NSDictionary *)[self.content objectAtIndex:indexPath.row];
    //cell.textLabel.text = [item objectForKey:@"mainTitleKey"];
    //cell.detailTextLabel.text = [item objectForKey:@"secondaryTitleKey"];
    //NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //cell.imageView.image = theImage;
    //return cell;
    
    ///////////////////

    
}

