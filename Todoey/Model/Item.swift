//
//  Item.swift
//  Todoey
//
//  Created by Anastasia Lenina on 18.04.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object{
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var date : Date?
    @Persisted var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
