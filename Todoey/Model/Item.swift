//
//  Item.swift
//  Todoey
//
//  Created by Anastasia Lenina on 14.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

class Item : Codable {
    var title: String
    var done: Bool
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
