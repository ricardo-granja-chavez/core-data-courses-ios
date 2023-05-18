//
//  ViewController.swift
//  Caminatas
//
//  Created by Ricardo Granja Chávez on 17/05/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var caminataTableView: UITableView!
    
//    var caminatas: [Date] = []
    var currentPerson: Person?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    var managedContext: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caminataTableView.delegate = self
        caminataTableView.dataSource = self
        
        let personName = "Ricardo"
        let personFetch: NSFetchRequest<Person> = Person.fetchRequest()
        personFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Person.name), personName)
        
        do {
            let results = try self.managedContext?.fetch(personFetch)
            
            if let results = results, !results.isEmpty {
                self.currentPerson = results.first
            } else {
                if let managedContext = self.managedContext {
                    self.currentPerson = Person(context: managedContext)
                    currentPerson?.name = personName
                    
                    try managedContext.save()
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @IBAction func addCaminata(_ sender: Any) {
//        self.caminatas.append(Date())
        
        if let managedContext = self.managedContext {
            let caminata = Caminata(context: managedContext)
            caminata.date = Date()
            
            if let person = self.currentPerson,
               let caminatas = person.caminatas?.mutableCopy() as? NSMutableOrderedSet {
                caminatas.add(caminata)
                person.caminatas = caminatas
            }
            
            do {
                
                try managedContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        caminataTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let caminatas = self.currentPerson?.caminatas else { return 1 }
        return caminatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let caminata = self.currentPerson?.caminatas?[indexPath.row] as? Caminata,
              let fechaDeCaminata = caminata.date else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCaminatas", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = self.dateFormatter.string(from: fechaDeCaminata)
        cell.contentConfiguration = content
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let caminata = self.currentPerson?.caminatas?[indexPath.row] as? Caminata,
              editingStyle == .delete else { return }
        
        if let managedContext = self.managedContext {
            managedContext.delete(caminata)
            
            do {
                try managedContext.save()
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
