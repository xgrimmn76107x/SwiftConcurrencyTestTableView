//
//  NonCopyableViewController.swift
//  TestConcurrency
//
//  Created by JayHsia on 2024/7/31.
//

import UIKit

class NonCopyableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createUser()
    }
    
    func createUser() {
        let newUser = User(name: "Anonymous")

        let userCopy = newUser
//        print(newUser.name)
    }
    struct MissionImpossibleMessage: ~Copyable {
        private var message: String

        init(message: String) {
            self.message = message
        }

        consuming func read() {
            print(message)
        }
    }
    func createMessage() {
        let message = MissionImpossibleMessage(message: "You need to abseil down a skyscraper for some reason.")
        message.read()
    }

}

struct User: ~Copyable {
    var name: String
}
