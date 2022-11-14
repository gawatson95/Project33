//
//  ViewController.swift
//  Project33
//
//  Created by Grant Watson on 11/8/22.
//

import CloudKit
import UIKit

class ViewController: UITableViewController {
    static var isDirty = true
    var whistles = [Whistle]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "What's that Whistle?"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWhistle))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: nil, action: nil)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @objc func addWhistle() {
        let vc = RecordWhistleViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if ViewController.isDirty {
            loadWhistles()
        }
    }
    
    func loadWhistles() {
        let predicate = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Whistles", predicate: predicate)
        query.sortDescriptors = [sort]
        
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["genre", "comments"]
        operation.resultsLimit = 50
        
        var newWhistles = [Whistle]()
        
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let whistle = Whistle()
                whistle.recordID = recordID
                whistle.genre = record["genre"]
                whistle.comments = record["comments"]
                newWhistles.append(whistle)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        operation.queryResultBlock = { [weak self] result in
            switch result {
            case .success:
                ViewController.isDirty = false
                self?.whistles = newWhistles
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure:
                let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching whistles. Please try again.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(ac, animated: true)
            }
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func makeAttributedString(title: String, subtitle: String) -> NSAttributedString {
        let titleAttrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.systemIndigo]
        let subtitleAttrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline)]
        
        let titleString = NSMutableAttributedString(string: title, attributes: titleAttrs)
        
        if subtitle.count > 0 {
            let subtitleString = NSAttributedString(string: "\n\(subtitle)", attributes: subtitleAttrs)
            titleString.append(subtitleString)
        }
        
        return titleString
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var config = UIListContentConfiguration.cell()
        config.attributedText = makeAttributedString(title: whistles[indexPath.row].genre, subtitle: whistles[indexPath.row].comments ?? "")
        cell.textLabel?.numberOfLines = 0
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whistles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ResultsViewController()
        vc.whistle = whistles[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

