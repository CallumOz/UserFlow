//
//  TrackEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol TrackEntityType {
    var title: String? { get }
    var titleShort: String? { get }
    var duration: Int? { get }

    var artist: ArtistEntity? { get }
}

struct TrackEntity: TrackEntityType {
    let title: String?
    let titleShort: String?
    let duration: Int?

    let artist: ArtistEntity?

    init(json: JSON) {
        self.title = json["title"].string
        self.titleShort = json["title_short"].string
        self.duration = json["duration"].int

        self.artist = ArtistEntity(json: json["artist"])
    }
}

