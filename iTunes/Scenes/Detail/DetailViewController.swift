//
//  DetailViewController.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: UIViewController {
    
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
        label.font = .boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 2
        return label
    }()
    
    let installButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20.0)
        var configuration = UIButton.Configuration.filled()
        configuration.title = "받기"
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .systemBlue
        configuration.contentInsets = .init(top: 8, leading: 12, bottom: 8, trailing: 12)
        configuration.cornerStyle = .medium
        button.configuration = configuration
        return button
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "잠화점 의류"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        return label
    }()
    
    var item: Item?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension DetailViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureConstraints() {
        [
            productImageView,
            productTitleLabel,
            installButton,
            categoryLabel
        ].forEach { view.addSubview($0) }
        
        productImageView.snp.makeConstraints {
            $0.size.equalTo(120)
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
        }
        
        productTitleLabel.snp.makeConstraints {
            $0.top.equalTo(productImageView).offset(8.0)
            $0.leading.equalTo(productImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        installButton.snp.makeConstraints {
            $0.bottom.equalTo(productImageView)
            $0.leading.equalTo(productTitleLabel)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(24.0)
            $0.bottom.equalTo(installButton)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        guard let item = item else { return }
        
        let imageURL = URL(string: item.image)
        let placeholderImage = UIImage(systemName: "photo")
        productImageView.kf.setImage(with: imageURL, placeholder: placeholderImage)
        productTitleLabel.text = item.title.htmlEscaped
        categoryLabel.text = item.category1
    }
    
    func bind() {
        
    }
}
