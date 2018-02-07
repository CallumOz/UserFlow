//
//  PlaylistTrackCellViewModel.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift

protocol PlaylistTrackCellViewModelType: class {
    var title: Variable<String?> { get }
    var artist: Variable<String?> { get }
    var duration: Variable<TimeInterval?> { get }
}

class PlaylistTrackCellViewModel: PlaylistTrackCellViewModelType {
    let title: Variable<String?>
    let artist: Variable<String?>
    let duration: Variable<TimeInterval?>

    private let track: TrackEntityType
    private let disposeBag = DisposeBag()

    init(track: TrackEntityType) {
        self.track = track

        self.title = Variable(track.titleShort)
        self.artist = Variable(track.artist?.name)
        self.duration = Variable(track.duration.flatMap(TimeInterval.init))
    }
}

