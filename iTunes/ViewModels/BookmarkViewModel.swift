//
//  BookmarkViewModel.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/7/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BookmarkViewModel: ViewModelBase {
    struct Input {
        let viewWillAppear: Observable<Bool>
        let itemSelected: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<Bookmark>.Element)>
    }
    
    struct Output {
        let bookmarkList: Driver<[Bookmark]>
    }
    
    var disposBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let bookmarkList = PublishRelay<[Bookmark]>()
        
         input.viewWillAppear
            .subscribe { _ in
                let fetchedBookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
                
                bookmarkList.accept(fetchedBookmarkList)
            }
            .disposed(by: disposBag)
        
        input.itemSelected
            .subscribe { indexPath, bookmark in
                let isContained = RealmManager.shared.read(Bookmark.self).contains { $0.productId == bookmark.productId }
                if isContained {
                    RealmManager.shared.delete(bookmark)
                    
                    let updatedBookmarkList: [Bookmark] = RealmManager.shared.read(Bookmark.self).map { $0 }
                    
                    bookmarkList.accept(updatedBookmarkList)
                } else {
                    print("이미 삭제된 항목입니다.")
                }
            }
            .disposed(by: disposBag)
        
        return Output(
            bookmarkList: bookmarkList.asDriver(onErrorJustReturn: [])
        )
    }
}
