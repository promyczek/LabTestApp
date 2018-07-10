//
//  DataModel.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataModel: NSObject {

    var categoriesDictionary = [String : ArticleCategory]()
    
    var selectedCategoryId: String = ""
    
    func articlesFromJSON(jsonObject: JSON) -> [Article] {
        guard let array = jsonObject.array else {
            log.warning("invalid JSON format")
            return []
        }
        var tmpArticles: [Article] = []
        for item in array {
            if let article = Article.fromJSON(jsonObject: item) {
                tmpArticles.append(article)
            }
        }
        return tmpArticles
    }
    
    func categoriesFromJSON(jsonObject: JSON) -> [ArticleCategory] {
        guard let array = jsonObject.array else {
            log.warning("invalid JSON format")
            return []
        }
        var tmpCategories: [ArticleCategory] = []
        for item in array {
            if let category = ArticleCategory.fromJSON(jsonObject: item) {
                tmpCategories.append(category)
            }
        }
        return tmpCategories
    }
    
    func setCategories(categoriesArray: [ArticleCategory]) {
        for item in categoriesArray {
            categoriesDictionary[item.id] = item
        }
        
        if let firstCategory = categoriesArray.first {
            selectedCategoryId = firstCategory.id
        }
    }
    
    func categories() -> [ArticleCategory] {
        let categoriesArray = categoriesDictionary.map({ $0.value })
        return categoriesArray.sorted(by: {$0.title < $1.title})
    }
}

