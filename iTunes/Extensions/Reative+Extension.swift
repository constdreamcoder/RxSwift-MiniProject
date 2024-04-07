//
//  Reative+Extension.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/7/24.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<Bool> {
    return methodInvoked(#selector(UIViewController.viewWillAppear))
       .map { $0.first as? Bool ?? false }
  }
}
