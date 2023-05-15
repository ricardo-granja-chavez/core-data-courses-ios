//
//  ViewController.swift
//  Automoviles
//
//  Created by Ricardo Granja Chávez on 11/03/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var carPictureImageView: UIImageView!
    
    @IBOutlet weak var brandSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var numberTestsLabel: UILabel!
    @IBOutlet weak var lastTestLabel: UILabel!
    
    var managedContext: NSManagedObjectContext!
    var currentCar: Automovil!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveDataPlistInCoreData()
        
        self.startData()
    }

    @IBAction func segmentedControl(_ sender: Any) {
        guard let segmentedControl = sender as? UISegmentedControl,
              let selectedCar = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) else { return }
        let request = NSFetchRequest<Automovil>(entityName: "Automovil")
        request.predicate = NSPredicate(format: "busqueda == %@", selectedCar)
        
        do {
            let results = try managedContext.fetch(request)
            self.currentCar = results.first!
            
            self.fillInformation(car: self.currentCar)
        } catch let error as NSError {
            print("No pude recuperar datos \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func probar(_ sender: Any) {
        let timesTested = self.currentCar.vecesProbado
        
        self.currentCar.vecesProbado = timesTested + 1
        self.currentCar.ultimaPrueba = Date()
        
        do {
            try self.managedContext.save()
            
            self.fillInformation(car: self.currentCar)
        } catch let error as NSError {
            print("No se pudo guardar datos nuevo: \(error)")
        }
    }
    
    @IBAction func qualify(_ sender: Any) {
        let alert = UIAlertController(title: "Clasificación", message: "Califica el Automovil", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancelar", style: .default)
        let save = UIAlertAction(title: "Guardar", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let text = textField.text,
            let calification = Double(text) else { return }
            
            self.currentCar.calificacion = calification
            
            do {
                try self.managedContext.save()
                
                self.fillInformation(car: self.currentCar)
            } catch let error as NSError {
                if error.domain == NSCocoaErrorDomain && (error.code == NSValidationNumberTooLargeError || error.code == NSValidationNumberTooSmallError) {
                    self.qualify(self.currentCar!)
                } else {
                    print("No pude recuperar datos \(error), \(error.userInfo)")
                }
            }
        }
        
        alert.addTextField { textField in
            textField.keyboardType = .decimalPad
        }
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true)
    }
    
    private func saveDataPlistInCoreData() {
        let request = NSFetchRequest<Automovil>(entityName: "Automovil")
        request.predicate = NSPredicate(format: "nombre != nil")
        
        let amount = try! managedContext.count(for: request)
        
        if amount > 0 {
            // La informacion inicial de nuestro Plist ya esta en Core Data
            print("Core Data ya tiene la información inicial del Plist o el usuario ya genero datos nuevos")
            return
        } else {
            print("Se ingresarán los datos iniciales que están en ListaDatosIniciales.plist")
            
            let pathPlist = Bundle.main.path(forResource: "ListaDatosIniciales",ofType: "plist")
            let arrayDataPlist = NSArray(contentsOfFile: pathPlist!)!
            
            for dictionaryDataPlist in arrayDataPlist {
                let entity = NSEntityDescription.entity(forEntityName: "Automovil",in: managedContext)!
                let car = Automovil(entity: entity, insertInto: self.managedContext)
                let dictionary = dictionaryDataPlist as! [String: Any]
                
                car.nombre = dictionary["nombre"] as? String
                car.busqueda = dictionary["busqueda"] as? String
                car.calificacion = dictionary["calificacion"] as! Double
                
                let fileName = dictionary["nombreImagen"] as? String
                let image = UIImage(named: fileName!)
                let imageJPEG = image!.jpegData(compressionQuality: 0.5)!
                
                car.datosImagen = imageJPEG
                car.ultimaPrueba = dictionary["ultimaPrueba"] as? Date
                
                let timesTested = dictionary["vecesProbado"] as! NSNumber
                
                car.vecesProbado = timesTested.int32Value
            }
            
            try! managedContext.save()
            
        }
    }
    
    private func fillInformation(car: Automovil) {
        guard let dataImage = car.datosImagen,
              let lastTest = car.ultimaPrueba else { return }
        
        // IBOutlets
        carPictureImageView.image = UIImage(data: dataImage)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        lastTestLabel.text = "Última prueba: " + formatter.string(from: lastTest)
        
        modelLabel.text = car.nombre
        ratingLabel.text = "Calificación: \(car.calificacion)"
        numberTestsLabel.text = "Veces probado: \(car.vecesProbado)"
    }
    
    private func startData() {
        let firstTitle = brandSegmentedControl.titleForSegment(at: 0)!
        let request = NSFetchRequest<Automovil>(entityName: "Automovil")
        request.predicate = NSPredicate(format: "busqueda == %@", firstTitle)
        
        do {
            let results = try managedContext.fetch(request)
            self.currentCar = results.first!
            
            self.fillInformation(car: self.currentCar)
        } catch let error as NSError {
            print("No pude recuperar datos \(error), \(error.userInfo)")
        }
    }
}

