//
//  SearchViewController.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        return tableView
    }()
    
    let recentKeywordTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RecentKeywordTableViewCell.self, forCellReuseIdentifier: RecentKeywordTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel = SearchViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension SearchViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "검색"
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchVC = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchVC
    }
    
    func configureConstraints() {
        [
            tableView,
            recentKeywordTableView,
        ].forEach { view.addSubview($0) }
       
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        recentKeywordTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.searchController?.searchBar.placeholder = "게임 앱, 스토리 등"
    }
    
    func bind() {
        guard let searchController = navigationItem.searchController else { return }
        
        let itemSelected = Observable.zip(
            recentKeywordTableView.rx.itemSelected,
            recentKeywordTableView.rx.modelSelected(String.self)
        )
        
        let itemDeleted = Observable.zip(
            recentKeywordTableView.rx.itemDeleted,
            recentKeywordTableView.rx.modelDeleted(String.self)
        )
        
        let input = SearchViewModel.Input(
            viewWillAppaer: self.rx.viewWillAppear,
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked,
            searchText: searchController.searchBar.rx.text.orEmpty,
            textDidBeginEditing: searchController.searchBar.rx.textDidBeginEditing,
            textDidEndEditing: searchController.searchBar.rx.textDidEndEditing,
            cancelButtonClicked: searchController.searchBar.rx.cancelButtonClicked,
            itemSelected: itemSelected,
            itemDeleted: itemDeleted
        )
                            
        let output = viewModel.transform(input: input)
        
        output.recentKeywordList
            .drive(recentKeywordTableView.rx.items(cellIdentifier: RecentKeywordTableViewCell.identifier, cellType: RecentKeywordTableViewCell.self)) { row, element, cell in
                cell.recentKeywordLabel.text = element
            }
            .disposed(by: disposeBag)
        
        output.productList
            .drive(tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { [weak self] row, element, cell in
                guard let self else { return }
                
                cell.item = element

                cell.delegate = viewModel
                cell.bind()
                
                let imageURL = URL(string: element.image)
                let placeholderImage = UIImage(systemName: "photo")
                cell.productImageView.kf.setImage(with: imageURL, placeholder: placeholderImage)
                cell.productTitleLabel.text = element.title.htmlEscaped
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            tableView.rx.itemSelected,
            tableView.rx.modelSelected(Item.self)
        )
        .bind(with: self) { owner, value in
            let detailVC = DetailViewController()
            detailVC.item = value.1
            owner.navigationController?.pushViewController(detailVC, animated: true)
        }
        .disposed(by: disposeBag)
        
        output.searchText
            .drive(with: self) { owner, searchText in
                if searchText.isEmpty {
                    owner.recentKeywordTableView.isHidden = false
                } else {
                    owner.recentKeywordTableView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.cancelButtonClicked
            .drive(with: self) { owner, _ in
                owner.recentKeywordTableView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.itemSelected
            .drive(with: self) { owner, keyword in
                searchController.searchBar.text = keyword
                owner.recentKeywordTableView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}
