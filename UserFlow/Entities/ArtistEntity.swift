//
//  ArtistEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ArtistEntityType {
    var name: String? { get }
}

struct ArtistEntity: ArtistEntityType {
    let name: String?

    init(json: JSON) {
        self.name = json["name"].string
    }
}

