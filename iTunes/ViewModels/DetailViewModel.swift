//
//  DetailViewModel.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelBase {
        
    struct Input {
        let installButtonTap: ControlEvent<Void>
        let item: Observable<Item>
    }
    
    struct Output {
        
    }
    
    var disposBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        input.installButtonTap
            .withLatestFrom(input.item)
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
        
        return Output()
    }
    
}
