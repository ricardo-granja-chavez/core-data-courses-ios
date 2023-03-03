//
//  TableViewController.swift
//  GuardaPalabras
//
//  Created by Ricardo Granja Chávez on 02/03/23.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {

    var managedObjects: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Lista")
        
        do {
            self.managedObjects = try manageContext.fetch(fetchRequest)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { self.managedObjects.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let managedObject = self.managedObjects[indexPath.row]
        
        content.text = managedObject.value(forKey: "palabra") as? String
        cell.contentConfiguration = content

        return cell
    }
    
    @IBAction func agregarPalabras(_ sender: Any) {
        let alerta = UIAlertController(title: "Nueva Palabra", message: "Agrega Palabra Nueva", preferredStyle: .alert)
        let guardar = UIAlertAction(title: "Agregar", style: .default) { UIAlertAction in
            guard let textfield = alerta.textFields?.first,
                  let texto = textfield.text else { return }
            
            self.guardarPalabra(palabra: texto)
            self.tableView.reloadData()
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel)
        
        alerta.addTextField()
        alerta.addAction(guardar)
        alerta.addAction(cancelar)
        
        self.present(alerta, animated: true)
    }
    
    func guardarPalabra(palabra: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let manageContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Lista", in: manageContext) else { return }
        let managedObject = NSManagedObject(entity: entity, insertInto: manageContext)
        
        managedObject.setValue(palabra, forKey: "palabra")
        appDelegate.saveContext()
        
        self.managedObjects.append(managedObject)
    }
}
