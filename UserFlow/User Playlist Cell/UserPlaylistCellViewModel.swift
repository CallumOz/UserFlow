//
//  UserPlaylistCellViewModel.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import Foundation
import RxSwift

protocol UserPlaylistCellViewModelType: class {
    var logo: Variable<URL?> { get }
    var title: Variable<String?> { get }
}

class UserPlaylistCellViewModel: UserPlaylistCellViewModelType {
    let logo: Variable<URL?>
    let title: Variable<String?>

    let playlist: PlaylistEntityType

    init(playlist: PlaylistEntityType) {
        self.playlist = playlist

        self.logo = Variable(playlist.picture)
        self.title = Variable(playlist.title)
    }
}

