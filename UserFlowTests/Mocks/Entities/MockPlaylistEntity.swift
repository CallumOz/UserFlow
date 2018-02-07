//
//  MockPlaylistEntity.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
@testable import UserFlow

struct MockPlaylistEntity: PlaylistEntityType {
    var title: String?
    var duration: Int?
    var tracklist: URL?
    var picture: URL?
    var creator: UserEntityType?

    init(title: String? = nil,
         duration: Int? = nil,
         tracklist: URL? = nil,
         picture: URL? = nil,
         creator: UserEntityType? = nil) {
        self.title = title
        self.duration = duration
        self.tracklist = tracklist
        self.picture = picture
        self.creator = creator
    }
}

