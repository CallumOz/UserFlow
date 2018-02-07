//
//  MockTrackEntity.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
@testable import UserFlow

struct MockTrackEntity: TrackEntityType {
    var title: String?
    var titleShort: String?
    var duration: Int?
    var artist: ArtistEntityType?

    init(title: String? = nil,
         titleShort: String? = nil,
         duration: Int? = nil,
         artist: ArtistEntityType? = nil) {
        self.title = title
        self.titleShort = titleShort
        self.duration = duration
        self.artist = artist
    }
}

