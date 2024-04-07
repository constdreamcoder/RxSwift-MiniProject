//
//  BookmarkCollectionViewCell.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/7/24.
//

import UIKit
import SnapKit

final class BookmarkCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: BookmarkCollectionViewCell.self)
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .darkGray
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BookmarkCollectionViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
        contentView.addSubview(productImageView)
        
        productImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
}
