//
//  UIViewControllerConfiguration.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/5/24.
//

import Foundation

@objc protocol UIViewControllerConfiguration {
    /// UIViewController NavigationBar 설정
    func configureNavigationBar()
    /// UIViewController 내부 Constraints 설정
    func configureConstraints()
    /// UIViewController 내부 UI 설정
    func configureUI()
    /// UIViewController 내부 나머지 설정 세팅
    @objc optional func configureOtherSettings()
    /// UIViewController와 ViewModel 간 바인딩 설정
    func bind()
}
