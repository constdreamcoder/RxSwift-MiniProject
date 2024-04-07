//
//  Bookmark.swift
//  iTunes
//
//  Created by SUCHAN CHANG on 4/6/24.
//

import Foundation
import RealmSwift

final class Bookmark: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var productId: String
    @Persisted var productTitle: String
    @Persisted var productImage: String
    @Persisted var productCategory1: String
    
    convenience init(
        productId: String,
        productTitle: String,
        productImage: String,
        productCategory1: String
    ) {
        self.init()
        self.productId = productId
        self.productTitle = productTitle
        self.productImage = productImage
        self.productCategory1 = productCategory1
    }
}
