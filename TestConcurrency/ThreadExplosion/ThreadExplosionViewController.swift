//
//  ThreadExplosionViewController.swift
//  TestConcurrency
//
//  Created by JayHsia on 2023/11/21.
//

import UIKit

enum ThreadExplosionItemSection {
    case dispatchGlobal
    case samePriorityLevelAtOnce
    case highToLowAtOnce
    case lowToHighAtOnce
    case lowToHighBreakInBetween
    case lotOfActor
    
    var description: String {
        switch self {
        case .dispatchGlobal:
            return "dispatchGlobal"
        case .samePriorityLevelAtOnce:
            return "samePriorityLevelAtOnce"
        case .highToLowAtOnce:
            return "highToLowAtOnce"
        case .lowToHighAtOnce:
            return "lowToHighAtOnce"
        case .lowToHighBreakInBetween:
            return "lowToHighBreakInBetween"
        case .lotOfActor:
            return "lotOfActor"
        }
    }
}

class ThreadExplosionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var itemSections: [ThreadExplosionItemSection] = {
        return [
            .dispatchGlobal,
            .samePriorityLevelAtOnce,
            .highToLowAtOnce,
            .lowToHighAtOnce,
            .lowToHighBreakInBetween,
            .lotOfActor
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
    }
}

extension ThreadExplosionViewController: UITableViewDelegate, UITableViewDataSource {
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
        switch itemSections[indexPath.row] {
        case .dispatchGlobal:
            dispatchGlobal()
        case .samePriorityLevelAtOnce:
            samePriorityLevelAtOnce()
        case .highToLowAtOnce:
            highToLowAtOnce()
        case .lowToHighAtOnce:
            lowToHighAtOnce()
        case .lowToHighBreakInBetween:
            lowToHighBreakInBetween()
        case .lotOfActor:
            lotOfActor()
        }
    }

    func dispatchGlobal() {
        for index in 1...1500 {
            HeavyWork.dispatchGlobal(seconds: 3, index: index)
        }
    }
    
    // Test 1: Creating Tasks with Same Priority Level
    func samePriorityLevelAtOnce() {
        for index in 1...150 {
            HeavyWork.runUserInitiatedTask(seconds: 3, index: index)
        }
    }
    // Test 2: Creating Tasks from High to Low Priority Level All at Once
    func highToLowAtOnce() {
        for index in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3, index: index)
        }

        for index in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3, index: index)
        }

        for index in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3, index: index)
        }
    }
    // Test 3: Creating Tasks from Low to High Priority Level All at Once
    func lowToHighAtOnce() {
        for index in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3, index: index)
        }

        for index in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3, index: index)
        }

        for index in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3, index: index)
        }
    }
    // Test 4: Creating Tasks from Low to High Priority Level with Break in Between
    func lowToHighBreakInBetween() {
        
        for index in 1...30 {
            HeavyWork.runBackgroundTask(seconds: 3, index: index)
        }

        sleep(3)
        print("⏰ 1st break...")

        for index in 1...30 {
            HeavyWork.runUtilityTask(seconds: 3, index: index)
        }

        sleep(3)
        print("⏰ 2nd break...")

        for index in 1...30 {
            HeavyWork.runUserInitiatedTask(seconds: 3, index: index)
        }
    }
    
    func lotOfActor() {
        for index in 1...150 {
            HeavyWork.lotOfActor(index: index)
        }
    }
    
}
