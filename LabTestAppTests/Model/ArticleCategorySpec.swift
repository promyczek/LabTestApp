//
//  CategorySpec.swift
//  LabTestAppTests
//
//  Created by Anna Zamora on 27/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import LabTestApp

class ArticleCategorySpec: QuickSpec {
    override func spec() {
        describe("Category") {
            
            context("when parsing object from JSON") {
                context("when JSON is valid") {
                    let jsonString = """
                    {
                        "id" : "about",
                        "webTitle" : "About"
                    }
                    """
                    var category: ArticleCategory!
                    beforeEach {
                        let jsonObj = JSON(parseJSON: jsonString)
                        category = ArticleCategory.fromJSON(jsonObject: jsonObj)
                    }
                    it ("should create category object and set all properties") {
                        expect(category.id).to(equal("about"))
                        expect(category.title).to(equal("About"))
                    }
                    
                }
                
                context("when JSON is invalid") {
                    let jsonString = """
                    {
                        "id" : "about"
                    }
                    """
                    var category: ArticleCategory!
                    beforeEach {
                        let jsonObj = JSON(parseJSON: jsonString)
                        category = ArticleCategory.fromJSON(jsonObject: jsonObj)
                    }
                    it ("should return nil object") {
                        expect(category).to(beNil())
                    }
                    
                }
            }
        }
    }
}
