//
//  RecentKeywordTableViewCell.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/7/24.
//

import UIKit
import SnapKit

final class RecentKeywordTableViewCell: UITableViewCell {
    static let identifier = String(describing: RecentKeywordTableViewCell.self)
    
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .black
        return imageView
    }()
    
    let recentKeywordLabel: UILabel = {
        let label = UILabel()
        label.text = "검색어 키워드 자리입니다."
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0)
        return label
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

extension RecentKeywordTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        [
            searchImageView,
            recentKeywordLabel
        ].forEach { contentView.addSubview($0) }
        
        searchImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.size.equalTo(24.0)
        }
        
        recentKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(searchImageView)
            $0.leading.equalTo(searchImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
    
    }
    
    func bind() {
    
    }
}
