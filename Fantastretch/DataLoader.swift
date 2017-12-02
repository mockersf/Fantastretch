//
//  DataLoader.swift
//  Fantastretch
//
//  Created by François Mockers on 29/11/2017.
//  Copyright © 2017 Vleue. All rights reserved.
//

import UIKit

class DataLoader {

    static func add(exercise: Exercise, exerciseLoaded closure: (Exercise) -> Void) {
        print("adding \(exercise)")
        closure(exercise)
    }

    static func loadFrom(jsonUrl url: String, exerciseLoaded closure: @escaping (Exercise) -> Void) {
        if let jsonURL = URL(string: url) {
            let session = URLSession(configuration: .default)
            let downloadJsonTask = session.dataTask(with: jsonURL) { data, response, error in
                if let e = error {
                    print("Error downloading json definition: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded exercise list with response code \(res.statusCode)")
                        if res.statusCode == 200, let jsonData = data {
                            let json = try? JSONSerialization.jsonObject(with: jsonData, options: [])
                            loadJson(jsonArray: json as! [Any], exerciseLoaded: closure)
                        } else {
                            print("Couldn't get exercise list: json is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadJsonTask.resume()
        }
    }

    static func loadJson(jsonArray: [Any], exerciseLoaded closure: @escaping (Exercise) -> Void) {
        for jsonObject in jsonArray {
            let json = jsonObject as! [String: Any]
            guard let name = json["name"] as? String,
                let uuid: UUID = UUID(uuidString: json["uuid"] as? String ?? "")
            else {
                print("invalid json object: \(jsonObject)")
                continue
            }
            let explanation = json["explanation"] as? String ?? ""
            let sides = Repeat(rawValue: json["repeat"] as? String ?? "") ?? Repeat.defaultCase
            let muscle = Muscle(rawValue: json["muscle"] as? String ?? "") ?? Muscle.defaultCase
            let withImgUrl = json["imgUrl"] as? String

            if let imgUrl = withImgUrl,
                let imageURL = URL(string: imgUrl) {
                let session = URLSession(configuration: .default)
                let downloadPicTask = session.dataTask(with: imageURL) { data, response, error in
                    if let e = error {
                        print("Error downloading exercise picture: \(e)")
                    } else {
                        if let res = response as? HTTPURLResponse {
                            print("Downloaded exercise picture with response code \(res.statusCode)")
                            if let imageData = data {
                                let image = UIImage(data: imageData)
                                if let exercise = Exercise(name: name, explanation: explanation, photo: image, rating: 0,
                                                           sides: sides, muscle: muscle, id: uuid) {
                                    add(exercise: exercise, exerciseLoaded: closure)
                                }
                            } else {
                                print("Couldn't get image: Image is nil")
                            }
                        } else {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
                downloadPicTask.resume()
            } else {
                if let exercise = Exercise(name: name, explanation: explanation, photo: nil, rating: 0, sides: sides, muscle: muscle, id: uuid) {
                    add(exercise: exercise, exerciseLoaded: closure)
                }
            }
        }
    }
}
