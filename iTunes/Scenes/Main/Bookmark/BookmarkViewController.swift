//
//  BookmarkViewController.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class BookmarkViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionVeiw = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionVeiw.showsVerticalScrollIndicator = false
        
        collectionVeiw.register(BookmarkCollectionViewCell.self, forCellWithReuseIdentifier: BookmarkCollectionViewCell.identifier)
        return collectionVeiw
    }()
    
    let viewModel = BookmarkViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension BookmarkViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let itemSelected = Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(Bookmark.self)
        )
        
        let input = BookmarkViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear,
            itemSelected: itemSelected
        )
        
        let output = viewModel.transform(input: input)
        
        output.bookmarkList
            .drive(collectionView.rx.items(cellIdentifier: BookmarkCollectionViewCell.identifier, cellType: BookmarkCollectionViewCell.self)) { row, element, cell in
                let imageURL = URL(string: element.productImage)
                let placeholderImage = UIImage(systemName: "photo")
                cell.productImageView.kf.setImage(with: imageURL, placeholder: placeholderImage)
            }
            .disposed(by: disposeBag)
    }
}

extension BookmarkViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 16
        
        let layout = UICollectionViewFlowLayout()
        let itemSize = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: itemSize / 2, height: itemSize / 2)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        return layout
    }
}
