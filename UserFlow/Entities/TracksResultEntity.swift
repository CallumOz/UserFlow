//
//  TracksResultEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TracksResultEntityType {
    var data: [TrackEntityType]? { get }
    var next: URL? { get }
}

struct TracksResultEntity: TracksResultEntityType {
    let data: [TrackEntityType]?
    let next: URL?

    init(json: JSON) {
        self.data = json["data"].array?.map(TrackEntity.init)
        self.next = json["next"].url
    }
}

