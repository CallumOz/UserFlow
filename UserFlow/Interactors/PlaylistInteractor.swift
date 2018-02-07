//
//  PlaylistInteractor.swift
//  UserFlow
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

protocol PlaylistInteractorType: class {
    var title: Variable<String?> { get }
    var logo: Variable<URL?> { get }
    var author: Variable<String?> { get }
    var duration: Variable<TimeInterval?> { get }

    var tracks: Variable<[TrackEntityType]> { get }
    var hasMore: Variable<Bool> { get }

    func load() -> Observable<Void>
}

class PlaylistInteractor: PlaylistInteractorType {
    let title: Variable<String?>
    let logo: Variable<URL?>
    let author: Variable<String?>
    let duration: Variable<TimeInterval?>

    let tracks = Variable<[TrackEntityType]>([])
    let hasMore: Variable<Bool>

    private var nextURL: URL?

    private let playlist: PlaylistEntityType
    private let disposeBag = DisposeBag()

    init(playlist: PlaylistEntityType) {
        self.playlist = playlist
        self.nextURL = playlist.tracklist
        self.hasMore = Variable(self.nextURL != nil)

        self.title = Variable(playlist.title)
        self.logo = Variable(playlist.picture)
        self.author = Variable(playlist.creator?.name)
        self.duration = Variable(playlist.duration.flatMap(TimeInterval.init))
    }

    enum LoadError: Error {
        case invalidResponse
    }

    func load() -> Observable<Void> {
        let subject = PublishSubject<Void>()

        guard let url = nextURL else {
            subject.onCompleted()
            return subject
        }

        Alamofire.request(url).responseJSON { [weak self] (response) in
            if let error = response.error {
                subject.onError(error)
                return
            }

            guard let json = response.value.flatMap(JSON.init) else {
                subject.onError(LoadError.invalidResponse)
                return
            }

            let tracksResult = TracksResultEntity(json: json)

            if let tracks = self?.tracks.value, let newTracks = tracksResult.data {
                var tracks = tracks
                tracks.append(contentsOf: newTracks)
                self?.tracks.value = tracks
            }

            self?.nextURL = tracksResult.next
            self?.hasMore.value = tracksResult.next != nil

            subject.onCompleted()
        }

        return subject
    }
}

