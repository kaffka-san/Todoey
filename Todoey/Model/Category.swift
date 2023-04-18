//
//  Category.swift
//  Todoey
//
//  Created by Anastasia Lenina on 18.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @Persisted var name : String = ""
    @Persisted var items = List<Item>()
}
