//
//  Extensions.swift
//  NetflixClone
//
//  Created by Enrique Poyato Ortiz on 19/11/25.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
