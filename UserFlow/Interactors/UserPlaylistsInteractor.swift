//
//  UserPlaylistsInteractor.swift
//  UserFlow
//
//  Created by Callum Henshall on 03/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import SwiftyJSON

protocol UserPlaylistsInteractorType: class {
    var playlists: Variable<[PlaylistEntityType]> { get }
    var hasMore: Variable<Bool> { get }

    func load() -> Observable<Void>
}

class UserPlaylistsInteractor: UserPlaylistsInteractorType {
    let playlists = Variable<[PlaylistEntityType]>([])

    let hasMore = Variable<Bool>(true)

    private var nextURL: URL?

    private let userID: String
    private let disposeBag = DisposeBag()

    init(userID: String) {
        self.userID = userID
        self.nextURL = URL(string: "https://api.deezer.com/user/\(userID)/playlists")!
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

            let playlistResult = PlaylistsResultEntity(json: json)

            if let playlists = self?.playlists.value, let newPlaylists = playlistResult.data {
                var playlists = playlists
                playlists.append(contentsOf: newPlaylists)
                self?.playlists.value = playlists
            }

            self?.nextURL = playlistResult.next
            self?.hasMore.value = playlistResult.next != nil

            subject.onCompleted()
        }

        return subject
    }
}

