//
//  UITableViewCellConfiguration.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import Foundation

protocol UITableViewCellConfiguration {
    /// UITableViewCell 내부 Constraint 설정
    func configureConstraints()
    /// UITableViewCell UI 설정
    func configureUI()
    /// UITableViewCell ReactiveX 이벤트 처리
    func bind()
}
