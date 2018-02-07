//
//  PlaylistTrackTableViewCell.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit
import RxSwift

class PlaylistTrackTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!

    private var viewModelDisposeBag: DisposeBag?

    var viewModel: PlaylistTrackCellViewModelType? {
        didSet {
            viewModelDisposeBag = nil
            if let viewModel = viewModel {
                setupViewModel(viewModel: viewModel)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
    }

    private func setupViewModel(viewModel: PlaylistTrackCellViewModelType) {
        let disposeBag = DisposeBag()
        self.viewModelDisposeBag = disposeBag

        viewModel.title.asObservable()
            .subscribe(onNext: { [weak self] (title) in
                self?.titleLabel.text = title
            })
            .disposed(by: disposeBag)

        viewModel.artist.asObservable()
            .subscribe(onNext: { [weak self] (artist) in
                self?.artistLabel.text = artist
            })
            .disposed(by: disposeBag)

        let durationFormatter = DateComponentsFormatter()
        durationFormatter.allowedUnits = [.minute, .second]
        durationFormatter.zeroFormattingBehavior = .pad
        durationFormatter.unitsStyle = .positional

        viewModel.duration.asObservable()
            .map { (duration) -> String? in
                return duration.flatMap { (duration) -> String? in
                    return durationFormatter.string(from: duration)
                }
            }
            .subscribe(onNext: { [weak self] (duration) in
                self?.durationLabel.text = duration
            })
            .disposed(by: disposeBag)
    }
}

