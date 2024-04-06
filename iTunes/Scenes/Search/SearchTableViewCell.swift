//
//  SearchTableViewCell.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import UIKit
import SnapKit

final class SearchTableViewCell: UITableViewCell {
    static let identifier = String(describing: SearchTableViewCell.self)
    
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
    
    let productTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "예시 텍스트입니다."
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    let installButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20.0)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "받기"
        configuration.baseForegroundColor = .systemBlue
        configuration.baseBackgroundColor = .lightGray
        configuration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        configuration.cornerStyle = .medium
        button.configuration = configuration
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            productImageView,
            productTitleLabel,
            installButton
        ].forEach { contentView.addSubview($0) }
        
        productImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16.0)
            $0.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
        }
        
        productTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(productImageView)
            $0.leading.equalTo(productImageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(installButton.snp.leading).offset(-8.0)
        }
        
        installButton.snp.makeConstraints {
            $0.centerY.equalTo(productTitleLabel)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
    
    func bind() {
        
    }
}
