//
//  FirstViewController.swift
//  TestConcurrency
//
//  Created by JayHsia on 2023/11/21.
//

import UIKit

enum ItemSection {
    case threadExplosion
    case sendable
    
    var description: String {
        switch self {
        case .threadExplosion:
            return "Thread Explosion"
        case .sendable:
            return "Sendable"
        }
    }
}

class FirstViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var itemSections: [ItemSection] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSection()
        setupTableView()
    }
    
    func setupSection() {
        itemSections = [
            .threadExplosion,
            .sendable
        ]
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
    }


}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath)
        let item = itemSections[indexPath.row]
        cell.textLabel?.text = item.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch itemSections[indexPath.row] {
        case .threadExplosion:
            self.navigationController?.pushViewController(ThreadExplosionViewController(), animated: true)
        case .sendable:
            self.navigationController?.pushViewController(SendableViewController(), animated: true)
        }
    }
}

protocol CellIdentifiable {
    static var cellIdentifier: String { get }
}

extension CellIdentifiable where Self: UITableViewCell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellIdentifiable { }

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.cellIdentifier)
    }

    func registerNib(_ cellClass: UITableViewCell.Type) {
        register(UINib(nibName: cellClass.cellIdentifier, bundle: .main), forCellReuseIdentifier: cellClass.cellIdentifier)
    }

    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier) as? T else {
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        return cell
    }

    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.cellIdentifier, for: indexPath) as? T else {
            fatalError("Error dequeuing cell for identifier \(T.cellIdentifier)")
        }
        return cell
    }
}
