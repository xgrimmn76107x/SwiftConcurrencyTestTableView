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
        watchMovie()
        createMessage()
        createHighScore()
    }
    
    func createUser() {
        let newUser = User(name: "Anonymous")

        let userCopy = newUser
        print(userCopy.name)
    }
    
    struct Movie: ~Copyable {
        var name: String

        init(name: String) {
            self.name = name
        }

        deinit {
            print("\(name) is no longer available")
        }
    }

    func watchMovie() {
        let movie = Movie(name: "The Hunt for Red October")
        print("Watching \(movie.name)")
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
    
    struct HighScore: ~Copyable {
        var value = 0

        consuming func finalize() {
            print("Saving score to disk…")
            discard self
        }

        deinit {
            print("Deinit is saving score to disk…")
        }
    }

    func createHighScore() {
        var highScore = HighScore()
        highScore.value = 20
        highScore.finalize()
    }
}

struct User: ~Copyable {
    var name: String
}
