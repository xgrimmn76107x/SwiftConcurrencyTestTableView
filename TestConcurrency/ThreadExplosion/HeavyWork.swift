//
//  HeavyWork.swift
//  TestConcurrency
//
//  Created by JayHsia on 2023/11/21.
//

import Foundation

enum HeavyWork {
    static func dispatchGlobal(seconds: UInt32, index: Int) {
//        let queue = DispatchQueue(label: "qwe", attributes: .concurrent)
//        let workItem1 = DispatchWorkItem(flags: .barrier) {
//            print("🐱 DispatchQueue: \(Date()), index:\(index)")
//            sleep(seconds)
//        }
//        queue.async(execute: workItem1)
//
        DispatchQueue(label: "qwe", qos: .background).async {
            print("🐱 DispatchQueue: \(Date()), index:\(index)")
            sleep(seconds)
        }

//        DispatchQueue.global(qos: .background).async {
//            print("🐱 global: \(Date()), index:\(index)")
//            sleep(seconds)
//        }
    }

    static func runUserInitiatedTask(seconds: UInt32, index: Int) {
        Task(priority: .userInitiated) {
            print("🥸 userInitiated: \(Date()), index: \(index)")
//            try? await Task.sleep(seconds: seconds)
            sleep(seconds)
        }
    }

    static func runUtilityTask(seconds: UInt32, index: Int) {
        Task(priority: .utility) {
            print("☕️ utility: \(Date()), index: \(index)")
//            try? await Task.sleep(seconds: seconds)
            sleep(seconds)
        }
    }

    static func runBackgroundTask(seconds: UInt32, index: Int) {
        Task(priority: .background) {
            print("⬇️ background: \(Date()), index: \(index)")
//            try? await Task.sleep(seconds: seconds)
            sleep(seconds)
        }
    }

    static var account1 = BankAccount1()
    static var account2 = BankAccount2()
    static var account3 = BankAccount3()
    static var awaitSleep = false

    static func lotOfActor(index: Int) {
        Task(priority: .high) {
            await account1.increment(1, index: index, awaitSleep: awaitSleep)
        }
        Task(priority: .high) {
            await account2.increment(1, index: index, awaitSleep: awaitSleep)
        }
        Task(priority: .high) {
            await account3.increment(1, index: index, awaitSleep: awaitSleep)
        }
    }
}

@globalActor
actor SomeGlobalActor {
    static let shared = SomeGlobalActor()
}

actor BankAccount1 {
    var balance: Int = 0

    func increment(_ amount: Int, index: Int, awaitSleep: Bool) async {
        if awaitSleep {
            try? await Task.sleep(seconds: 3)
        } else {
            sleep(3)
        }
        balance += amount
        print("💵1 priority:\(String(describing: Task.basePriority)) \(Date()), balance:\(balance), index:\(index)")
    }
}

actor BankAccount2 {
    var balance: Int = 0

    func increment(_ amount: Int, index: Int, awaitSleep: Bool) async {
        if awaitSleep {
            try? await Task.sleep(seconds: 3)
        } else {
            sleep(3)
        }
        print("💵2 priority:\(String(describing: Task.basePriority)) \(Date()), balance:\(balance), index:\(index)")
    }
}

actor BankAccount3 {
    var balance: Int = 0

    func increment(_ amount: Int, index: Int, awaitSleep: Bool) async {
        if awaitSleep {
            try? await Task.sleep(seconds: 3)
        } else {
            sleep(3)
        }
        balance += amount
        print("💵3 priority:\(String(describing: Task.basePriority)) \(Date()), balance:\(balance), index:\(index)")
    }
}
