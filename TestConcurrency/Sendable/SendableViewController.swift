//
//  SendableViewController.swift
//  TestConcurrency
//
//  Created by JayHsia on 2023/12/27.
//

import UIKit

enum SendableItemSection {
    case dataRaceClass
    case actor
    case sendableStructure

    var description: String {
        switch self {
        case .dataRaceClass:
            return "dataRaceClass"
        case .actor:
            return "actor"
        case .sendableStructure:
            return "sendableStructure"
        }
    }
}

class SendableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var itemSections: [SendableItemSection] = [
        .dataRaceClass,
        .actor,
        .sendableStructure,
    ]

    let hotel = Hotel()
    var hotelSendable = HotelSendable()
    let hotelActor = HotelActor()

    let someActor = SomeActor()

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

extension SendableViewController: UITableViewDelegate, UITableViewDataSource {
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
        case .dataRaceClass:
            dataRaceClass()
        case .actor:
            actor()
        case .sendableStructure:
            sendableStructure()
        }
    }
    
    func dataRaceClass() {
        executeLoop { [weak self] number in
            guard let self else { return }
            hotel.room += number
            await testActorFunction(actor: someActor, hotel: hotel, number: number)
        }
    }

    func actor() {
        executeLoop { [weak self] number in
            guard let self else { return }
            await hotelActor.setRoom(number: number)
            await testFunctionActor(actor: self.someActor, hotel: self.hotelActor, number: number)
        }
    }

    func sendableStructure() {
        executeLoop { [weak self] number in
            guard let self else { return }
            hotelSendable.room += number
            await testFunctionSendable(actor: someActor, hotel: hotelSendable, number: number)
        }
    }
}

extension SendableViewController {
    func executeLoop(callback: @escaping (Int) async -> Void) {
        for number in 0 ..< 10000 {
            Task.detached(operation: {
                await callback(number)
            })
        }
    }

    func testActorFunction(actor: SomeActor, hotel: Hotel, number: Int) async {
        await actor.printHotelRoom(hotel: hotel, number: number)
    }

    func testFunctionSendable(actor: SomeActor, hotel: HotelSendable, number: Int) async {
        await actor.printHotelRoom(hotel: hotel, number: number)
    }

    func testFunctionActor(actor: SomeActor, hotel: HotelActor, number: Int) async {
        await actor.printHotelRoom(hotel: hotel, number: number)
    }
}

actor SomeActor {
    func printHotelRoom(hotel: Hotel, number: Int) async {
        print("hotel append: \(number), hotel:\(hotel.room)")
    }

    func printHotelRoom(hotel: HotelActor, number: Int) async {
        print("hotel append: \(number), hotel:\(await hotel.room)")
    }

    func printHotelRoom(hotel: HotelSendable, number: Int) async {
        print("hotel append: \(number), hotel:\(hotel.room)")
    }
}

class Hotel {
    var room: Int = 0

//    var room: Int {
//        get {
//            propertyLock.lock()
//            defer {
//                propertyLock.unlock()
//            }
//            return _room
//        }
//        set {
//            propertyLock.lock()
//            defer {
//                propertyLock.unlock()
//            }
//            _room = newValue
//        }
//    }
//
//    private var _room: Int = 0
//    private var propertyLock = NSLock()
}

actor HotelActor {
    var room: Int = 0

    func setRoom(number: Int) {
        room += number
    }
}

struct HotelSendable: Sendable {
    var room: Int = 0
}
