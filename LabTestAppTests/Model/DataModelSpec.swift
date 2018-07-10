//
//  DataModelSpec.swift
//  LabTestAppTests
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import LabTestApp

class DataModelSpec: QuickSpec {
    override func spec() {
        describe("DataModel") {
            context("when initialize object") {
                var dataModel: DataModel!
                beforeEach {
                    dataModel = DataModel()
                }
                
                it ("should return 0 categories") {
                    expect(dataModel.categories().count).to(equal(0))
                }
                
                it ("should return empty category id") {
                    expect(dataModel.selectedCategoryId).to(equal(""))
                }
            }
            
            context("when receive JSON with articles") {
                
                context("when JSON with articles is valid") {
                    let jsonString = """
                    [{
                        "webTitle" : "Arctic freeze: Britain",
                        "id" : "example.com",
                        "webUrl" : "www.example.com",
                        "webPublicationDate" : "2018-02-26T09:03:14Z",
                        "sectionId" : "uk-news"
                    },
                    {
                        "webTitle" : "Brexit: Corbyn wins",
                        "id" : "politics",
                        "webUrl" : "www.example.com",
                        "webPublicationDate" : "2018-02-26T12:58:24Z",
                        "sectionId" : "uk-news"
                    }]
                    """
                    
                    var dataModel: DataModel!
                    beforeEach {
                        dataModel = DataModel()
                        var category = ArticleCategory(title: "sample category", id: "sample", lastUpdate: Date(), articles: [])
                        let jsonObj = JSON(parseJSON: jsonString)
                        category.articles = dataModel.articlesFromJSON(jsonObject: jsonObj)
                        dataModel.setCategories(categoriesArray: [category])
                    }
                    
                    it ("should add parsed Article objects from JSON") {
                        expect(dataModel.categories().first?.articles.count).to(equal(2))
                    }
                }
                
                context("when JSON with articles is broken") {
                    let jsonString = """
                    [{
                        "webTitle" : "Arctic freeze: Britain",
                        "id" : "example.com",
                        "webUrl" : "www.example.com",
                        "sectionId" : "uk-news"
                    }
                    {
                        "webTitle" : "Brexit: Corbyn wins",
                        "id" : "politics",
                        "webUrl" : "www.example.com",
                        "webPublicationDate" : "2018-02-26T12:58:24Z",
                        "sectionId" : "uk-news"
                    }
                    """
                    
                    var dataModel: DataModel!
                    beforeEach {
                        dataModel = DataModel()
                        var category = ArticleCategory(title: "sample category", id: "sample", lastUpdate: Date(), articles: [])
                        let jsonObj = JSON(parseJSON: jsonString)
                        category.articles = dataModel.articlesFromJSON(jsonObject: jsonObj)
                        dataModel.setCategories(categoriesArray: [category])
                    }
                    
                    it ("should add parsed Article objects from JSON") {
                        expect(dataModel.categories().first?.articles.count).to(equal(0))
                    }
                }
            }
            
            context("when receive JSON with categories") {
                
                context("when JSON with categories is valid") {
                    
                    let jsonString = """
                    [{
                        "id" : "about",
                        "webTitle" : "About"
                    },
                    {
                        "id" : "animals-farmed",
                        "webTitle" : "Animals farmed"
                    },
                    {
                        "id" : "australia-news",
                        "webTitle" : "Australia news"
                    }]
                    """
                    
                    var dataModel: DataModel!
                    beforeEach {
                        dataModel = DataModel()
                        let jsonObj = JSON(parseJSON: jsonString)
                        dataModel.setCategories(categoriesArray: dataModel.categoriesFromJSON(jsonObject: jsonObj))
                    }
                    
                    it ("should return 3 categories objects") {
                        expect(dataModel.categories().count).to(equal(3))
                    }
                }
                
                context("When JSON with categories is broken") {
                    
                    let jsonString = """
                    [{
                        "id" : "about",
                        "webTitle" : "About"
                    },
                    {
                        "id" : "animals-farmed",
                        "webTitle" : "Animals farmed"
                    }
                    {
                        "id" : "australia-news",
                        "webTitle" : "Australia news"
                    }]
                    """
                    
                    var dataModel: DataModel!
                    beforeEach {
                        dataModel = DataModel()
                        let jsonObj = JSON(parseJSON: jsonString)
                        dataModel.setCategories(categoriesArray: dataModel.categoriesFromJSON(jsonObject: jsonObj))
                    }
                    
                    it ("should return 0 categories") {
                        expect(dataModel.categories().count).to(equal(0))
                    }
                }
            }
        }
    }
}
