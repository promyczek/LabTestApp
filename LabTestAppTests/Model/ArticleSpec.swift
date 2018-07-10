//
//  ArticleSpec.swift
//  LabTestAppTests
//
//  Created by Anna Zamora on 26/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Quick
import Nimble
import SwiftyJSON

@testable import LabTestApp

class ArticleSpec: QuickSpec {
    
    override func spec() {
        describe("Article") {
            context("when creating object using constructor") {
                let calendar = Calendar.current
                let dateComponents = DateComponents(calendar: calendar, year: 2018, month: 2, day: 26)
                let date = calendar.date(from: dateComponents)
                it("should set all object properties") {
                    let article = Article.mock()
                    expect(article.title).to(equal("title"))
                    expect(article.id).to(equal("id"))
                    expect(article.sectionId).to(equal("sectionId"))
                    expect(article.contentURL).to(equal("URL"))
                    expect(article.publicationDate).to(equal(date))
                }
            }
            
            context("when parsing object from JSON") {
                
                context("when JSON is valid") {
                    let jsonString = """
                    {
                        "webTitle" : "Arctic freeze: Britain",
                        "id" : "example.com",
                        "webUrl" : "www.example.com",
                        "webPublicationDate" : "2018-02-26T09:03:14Z",
                        "sectionId" : "uk-news"
                    }
                    """
                    
                    var article: Article!
                    beforeEach {
                        let jsonObj = JSON(parseJSON: jsonString)
                        article = Article.fromJSON(jsonObject:jsonObj)
                    }
                    
                    it("should set all object properties from JSON") {
                        expect(article.title).to(equal("Arctic freeze: Britain"))
                        expect(article.id).to(equal("example.com"))
                        expect(article.sectionId).to(equal("uk-news"))
                        expect(article.contentURL).to(equal("www.example.com"))
                    }
                    
                }
                
                context("when JSON is invalid") {
                    let invalidJsonString = """
                    {
                        "webTitle" : "Arctic freeze: Britain",
                        "id" : "example.com",
                        "webPublicationDate" : "2018-02-26T09:03:14Z",
                        "sectionId" : "uk-news"
                    }
                    """
                    
                    var article: Article!
                    beforeEach {
                        let jsonObj = JSON(parseJSON: invalidJsonString)
                        article = Article.fromJSON(jsonObject:jsonObj)
                    }
                    
                    it("should not initialize Article") {
                        expect(article).to(beNil())
                    }
                }
            }
            context("when object is created") {
                
                var article: Article?
                beforeEach {
                    article = Article.mock()
                }
                
                it("should return properly formated date") {
                    expect(article?.formattedDateString).to(equal("00:00 02-26-2018"))
                }
            }
        }
    }
}
