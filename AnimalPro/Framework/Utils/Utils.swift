//
//  Utils.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

class Utils {
    static func beautifulPrint<T: Codable>(_ model: T) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(model)
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString ?? "")
        } catch {
            print("ERROR: No se pudo imprimir el objeto")
        }
    }
}
