//
//  UserPlaylistCollectionViewCell.swift
//  UserFlow
//
//  Created by Callum Henshall on 04/02/2018.
//  Copyright © 2018 Callum Henshall. All rights reserved.
//

import UIKit
import RxSwift
import SDWebImage

class UserPlaylistCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    private var viewModelDisposeBag: DisposeBag?

    var viewModel: UserPlaylistCellViewModelType? {
        didSet {
            viewModelDisposeBag = nil
            if let viewModel = viewModel {
                setupViewModel(viewModel: viewModel)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .white
        self.selectedBackgroundView = selectedBackgroundView
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        viewModel = nil
    }

    private func setupViewModel(viewModel: UserPlaylistCellViewModelType) {
        let disposeBag = DisposeBag()
        self.viewModelDisposeBag = disposeBag

        viewModel.logo.asObservable()
            .subscribe(onNext: { [weak self] (url) in
                if let url = url {
                    self?.imageView.sd_setImage(with: url)
                }
                else {
                    self?.imageView.sd_cancelCurrentImageLoad()
                }
            })
            .disposed(by: disposeBag)

        viewModel.title.asObservable()
            .subscribe(onNext: { [weak self] (title) in
                self?.titleLabel.text = title
            })
            .disposed(by: disposeBag)
    }
}

