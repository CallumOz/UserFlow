//
//  UserEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol UserEntityType {
    var name: String? { get }
}

struct UserEntity: UserEntityType {
    let name: String?

    init?(json: JSON) {
        guard let name = json["name"].string else {
            return nil
        }
        self.name = name
    }
}

