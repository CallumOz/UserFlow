//
//  MockUserPlaylistsRouter.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 08/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit
@testable import UserFlow
import RxSwift

class MockUserPlaylistsRouter: UserPlaylistsRouterType {
    let calledShowPlaylistTracks = PublishSubject<Void>()

    func showPlaylistTracks(for playlist: PlaylistEntityType) {
        calledShowPlaylistTracks.onNext(())
    }
}
