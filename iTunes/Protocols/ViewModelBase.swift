//
//  ViewModelBase.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/5/24.
//

import Foundation
import RxSwift

protocol ViewModelBase {
    associatedtype Input
    associatedtype Output
    
    var disposBag: DisposeBag { get set }
    
    func transform(input: Input) -> Output
}
