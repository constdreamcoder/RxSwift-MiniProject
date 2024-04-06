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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.searchController?.searchBar.placeholder = "게임 앱, 스토리 등"
    }
    
    func bind() {
        guard let searchController = navigationItem.searchController else { return }
        
        let input = SearchViewModel.Input(
            searchButtonTap: searchController.searchBar.rx.searchButtonClicked,
            searchText: searchController.searchBar.rx.text.orEmpty
        )
            
        let output = viewModel.transform(input: input)
        
        output.movieList
            .drive(tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { row, element, cell in
                
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
        .subscribe(with: self) { owner, value in
            let detailVC = DetailViewController()
            detailVC.item = value.1
            owner.navigationController?.pushViewController(detailVC, animated: true)
        }
        .disposed(by: disposeBag)
        
       
    }
    
    
}
