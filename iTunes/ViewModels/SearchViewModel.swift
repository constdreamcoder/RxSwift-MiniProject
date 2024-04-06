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
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let movieList: Driver<[Item]>
    }
    
    var disposBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let movieList = PublishRelay<[Item]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .flatMap {
                NaverShoppingManager.shared.fetchMovieList(searchText: $0)
            }
            .debug()
            .subscribe(with: self, onNext: { owner, value in
                movieList.accept(value.items)
            })
            .disposed(by: disposBag)
            
        return Output(movieList: movieList.asDriver(onErrorJustReturn: []))
    }
}
