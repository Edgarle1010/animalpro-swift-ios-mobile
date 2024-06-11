//
//  String.swift
//  AnimalPro
//
//  Created by Edgar López Enríquez on 10/06/24.
//

import Foundation

extension String {
    /// Returns a `URL` if `self` can be used to initialize a `URL` instance, otherwise throws.
    /// - Returns: The `URL` initialized with `self`.
    /// - Throws:  An `NetworkError.invalidURL` instance.
    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NetworkError.invalidURL(url: self) }
        return url
    }
}
