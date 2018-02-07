//
//  PlaylistsResultEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PlaylistsResultEntityType {
    var data: [PlaylistEntityType]? { get }
    var next: URL? { get }
}

struct PlaylistsResultEntity: PlaylistsResultEntityType {
    let data: [PlaylistEntityType]?
    let next: URL?

    init(json: JSON) {
        self.data = json["data"].array?.map(PlaylistEntity.init)
        self.next = json["next"].url
    }
}

