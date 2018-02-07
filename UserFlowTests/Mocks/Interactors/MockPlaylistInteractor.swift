//
//  MockPlaylistInteractor.swift
//  UserFlowTests
//
//  Created by Callum Henshall on 07/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
@testable import UserFlow
import RxSwift

class MockPlaylistInteractor: PlaylistInteractorType {
    var title: Variable<String?>
    var logo: Variable<URL?>
    var author: Variable<String?>
    var duration: Variable<TimeInterval?>

    var tracks: Variable<[TrackEntityType]>
    var hasMore: Variable<Bool>

    init(title: String? = nil, logo: URL? = nil, author: String? = nil, duration: TimeInterval?, tracks: [TrackEntityType] = [], hasMore: Bool = true) {
        self.title = Variable(title)
        self.logo = Variable(logo)
        self.author = Variable(author)
        self.duration = Variable(duration)

        self.tracks = Variable(tracks)
        self.hasMore = Variable(hasMore)
    }

    let calledLoad = PublishSubject<Void>()
    let mockLoad = PublishSubject<Void>()

    func load() -> Observable<Void> {
        calledLoad.onNext(())
        return mockLoad
    }
}
