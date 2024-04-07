//
//  SearchViewModel.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/5/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelBase {
    
    struct Input {
        let viewWillAppaer: Observable<Bool>
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let textDidBeginEditing: ControlEvent<Void>
        let textDidEndEditing: ControlEvent<Void>
        let cancelButtonClicked: ControlEvent<Void>
        let itemSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<String>.Element)>
        let itemDeleted: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<String>.Element)>
    }
    
    struct Output {
        let recentKeywordList: Driver<[String]>
        let productList: Driver<[Item]>
        let searchText: Driver<String>
        let textDidEndEditing: Driver<Void>
        let cancelButtonClicked: Driver<Void>
        let itemSelected: Driver<String>
    }
    
    var disposBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let recentKeywordList = PublishRelay<[String]>()
        let productList = PublishRelay<[Item]>()
        
        input.viewWillAppaer
            .subscribe { _ in
                recentKeywordList.accept(UserDefaults.standard.recentKeywordList)
            }
            .disposed(by: disposBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map { searchText in
                let isExist = UserDefaults.standard.recentKeywordList.contains { $0 == searchText }
                
                if !isExist {
                    UserDefaults.standard.recentKeywordList = [searchText] + UserDefaults.standard.recentKeywordList
                    
                    recentKeywordList.accept(UserDefaults.standard.recentKeywordList)
                } else {
                    print("이미 존재하는 검색어 입니다.")
                }
                
                return searchText
            }
            .flatMap {
                NaverShoppingManager.shared.fetchMovieList(searchText: $0)
            }
            .subscribe {
                productList.accept($0.items)
            }
            .disposed(by: disposBag)
        
        input.textDidBeginEditing
            .subscribe { _ in
                productList.accept([])
            }
            .disposed(by: disposBag)
        
        input.itemSelected
            .flatMap {
                NaverShoppingManager.shared.fetchMovieList(searchText: $1)
            }
            .subscribe {
                productList.accept($0.items)
            }
            .disposed(by: disposBag)
        
        input.itemDeleted
            .subscribe { indexPath, keyword  in
                UserDefaults.standard.recentKeywordList.remove(at: indexPath.row)
                recentKeywordList.accept(UserDefaults.standard.recentKeywordList)
            }
            .disposed(by: disposBag)
        
        return Output(
            recentKeywordList: recentKeywordList.asDriver(onErrorJustReturn: []),
            productList: productList.asDriver(onErrorJustReturn: []),
            searchText: input.searchText.asDriver(),
            textDidEndEditing: input.textDidEndEditing.asDriver(),
            cancelButtonClicked: input.cancelButtonClicked.asDriver(),
            itemSelected: input.itemSelected.map{ $1 }.asDriver(onErrorJustReturn: "") 
        )
    }
}

extension SearchViewModel: SearchTableViewCellDelegate {
    func cellTransform(
        installButtonTap: ControlEvent<Void>,
        item: Observable<Item>
    ) {
        installButtonTap
            .withLatestFrom(item)
            .subscribe { item in
                let isExist = RealmManager.shared.read(Bookmark.self).contains { $0.productId == item.productId }
                
                if !isExist {
                    RealmManager.shared.getLocationOfDefaultRealm()
                    
                    let newBookmark = Bookmark(
                        productId: item.productId,
                        productTitle: item.title.htmlEscaped,
                        productImage: item.image,
                        productCategory1: item.category1
                    )
                    RealmManager.shared.write(newBookmark)
                } else {
                    print("이미 존재합니다")
                }
            }
            .disposed(by: disposBag)

    }
}
