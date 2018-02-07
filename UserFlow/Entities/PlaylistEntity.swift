//
//  PlaylistEntity.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol PlaylistEntityType {
    var title: String? { get }
    var duration: Int? { get }
    var nbTracks: Int? { get }

    var tracklist: URL? { get }
    var picture: URL? { get }

    var creator: UserEntity? { get }
}

struct PlaylistEntity: PlaylistEntityType {
    let title: String?
    let duration: Int?
    let nbTracks: Int?

    let tracklist: URL?
    let picture: URL?

    let creator: UserEntity?

    init(json: JSON) {
        self.title = json["title"].string
        self.duration = json["duration"].int
        self.nbTracks = json["nb_tracks"].int

        self.tracklist = json["tracklist"].url
        self.picture = json["picture"].url

        self.creator = UserEntity(json: json["creator"])
    }
}

