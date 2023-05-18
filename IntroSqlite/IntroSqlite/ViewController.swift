//
//  ViewController.swift
//  IntroSqlite
//
//  Created by Ricardo Granja Chávez on 18/05/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var modelSearchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func save(_ sender: Any) {
        if modelTextField.hasText && priceTextField.hasText {
            print("Si")
            self.startSaved()
        } else {
            print("No")
        }
    }
    
    @IBAction func search(_ sender: Any) {
        if modelSearchTextField.hasText {
            print("Sii")
            self.startSearched()
        } else {
            print("Noo")
        }
    }
    
    func startSaved() {
        
    }
    
    func startSearched() {
        
    }
}

