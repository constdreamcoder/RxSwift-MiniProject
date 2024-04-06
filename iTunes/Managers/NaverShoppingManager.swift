//
//  NaverShoppingManager.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import Foundation
import RxSwift
import Alamofire

final class NaverShoppingManager {
    static let shared = NaverShoppingManager()
    
    private init() {}
    
    func fetchMovieList(searchText: String) -> Observable<ShoppingModel> {
        return Observable.create { observer in
            let urlString = "https://openapi.naver.com/v1/search/shop.json"
            
            let headers: HTTPHeaders = [
                "X-Naver-Client-Id": APIKeys.naverClientId,
                "X-Naver-Client-Secret": APIKeys.naverClientSecret
            ]
            
            let parameters = [
                "query": searchText,
            ]
            
            AF.request(
                urlString,
                method: .get,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder(destination: .queryString),
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingModel.self) { response in
                switch response.result {
                case .success(let success):
                    observer.onNext(success)
                    observer.onCompleted()
                case .failure(let failure):
                    observer.onError(failure)
                }
            }
            
            return Disposables.create()
        }.debug()
    }
}
