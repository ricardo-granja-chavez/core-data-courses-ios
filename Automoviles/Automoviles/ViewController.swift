//
//  ViewController.swift
//  Automoviles
//
//  Created by Ricardo Granja Chávez on 11/03/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var fotografiaAutomovil: UIImageView!
    
    @IBOutlet weak var marcasSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var modeloLabel: UILabel!
    @IBOutlet weak var clasificacionLabel: UILabel!
    @IBOutlet weak var numeroPruebasLabel: UILabel!
    @IBOutlet weak var ultimaPruebaLabel: UILabel!
    
    var manageContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func segmentedControl(_ sender: Any) {
        
    }
    
    @IBAction func probar(_ sender: Any) {
        
    }
    
    @IBAction func calificar(_ sender: Any) {
        
    }
}

