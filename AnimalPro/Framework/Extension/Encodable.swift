//
//  Encodable.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

extension Encodable {
    func toString() -> String {
        if let data = encoded(){
            return data.toString()
        }
        return "Error al convertir el objeto a JSON"
    }
    
    func encoded()-> Data? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            return jsonData
        } catch {
            return nil
        }
    }
}
