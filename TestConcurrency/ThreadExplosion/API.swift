//
//  API.swift
//  TestConcurrency
//
//  Created by JayHsia on 2023/11/22.
//

import UIKit
import Foundation

class FetchImageManager {
    static let randomImageUrl = URL(string: "https://random.imagecdn.app/300/300")!
    @discardableResult
    static func downloadImage() async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: randomImageUrl)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw CancellationError()
        }
        return UIImage(data: data)!
    }
    
    static func downloadImage(completion: @escaping (UIImage?, Error?) -> Void) {
        URLSession.shared.dataTask(with: randomImageUrl) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, CancellationError())
            }
        }.resume()
    }
}


extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: UInt32) async throws {
        let duration = UInt64(seconds) * NSEC_PER_SEC
        try await Task.sleep(nanoseconds: duration)
    }
}
