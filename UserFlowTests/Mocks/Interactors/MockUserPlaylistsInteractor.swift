//
//  MockUserPlaylistsInteractor.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
@testable import UserFlow
import RxSwift

class MockUserPlaylistsInteractor: UserPlaylistsInteractorType {
    var playlists: Variable<[PlaylistEntityType]>
    var hasMore: Variable<Bool>

    init(playlists: [PlaylistEntityType] = [], hasMore: Bool = true) {
        self.playlists = Variable(playlists)
        self.hasMore = Variable(hasMore)
    }

    let calledLoad = PublishSubject<Void>()
    let mockLoad = PublishSubject<Void>()

    func load() -> Observable<Void> {
        calledLoad.onNext(())
        return mockLoad
    }
}

