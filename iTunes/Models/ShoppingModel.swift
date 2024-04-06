//
//  SearchModel.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import Foundation

struct ShoppingModel: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [Item]
}

struct Item: Decodable {
    let title: String
    let image: String
    let productId: String
    let lprice: String // 최저가
    let category1: String
    let category2: String
    let category3: String
    let category4: String
}
