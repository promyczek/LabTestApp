//
//  ConnectionManager.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

enum ApiServices {
    case refreshArticlesList(pageSize: Int, categoryId: String)
    case loadNextArticles(startPage: Int, pageSize: Int, categoryId: String)
    case articleDetails(id: String)
    case loadCategories
    case search(searchPhrase: String, pageSize: Int)
}

extension ApiServices: TargetType {

    var baseURL: URL {
        return URL(string: "https://content.guardianapis.com")!
    }
    
    var apiKey: String {
        return "450305c2-12f9-44bc-8465-59601e97dd21"
    }
    
    var path: String {
        switch self {
        case .refreshArticlesList:
            return "/search"
        case .loadNextArticles(_):
            return "/search"
        case .articleDetails(let id):
            return "/\(id)"
        case .loadCategories:
            return "/sections"
        case .search(_):
            return "/search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .refreshArticlesList(let pageSize, let categoryId):
            return .requestParameters(parameters: ["pageSize" : pageSize,
                                                   "api-key": apiKey,
                                                   "section" : categoryId],
                                      encoding: URLEncoding.queryString)
        
        case .loadNextArticles(let startPage, let pageSize, let categoryId):
            return .requestParameters(parameters: ["pageSize" : pageSize,
                                                   "api-key": apiKey,
                                                   "page": startPage,
                                                   "section" : categoryId],
                                      encoding: URLEncoding.queryString)
            
        case .loadCategories:
            return .requestParameters(parameters: ["api-key": apiKey],
                                      encoding: URLEncoding.queryString)
            
        case .search(let searchPhrase, let pageSize):
            return .requestParameters(parameters: ["pageSize" : pageSize,
                                                   "api-key": apiKey,
                                                   "q" : searchPhrase],
                                      encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}

enum HTTPStatusCode: Int {
    case success = 200,
    unauthorized = 401,
    notFound = 404,
    serverError = 500
}

class ConnectionManager: NSObject {
    private let dataModel: DataModel
    private let provider = MoyaProvider<ApiServices>()
    private let defaultPageSize = 15
    private let searchPageSize = 30
    
    init(with dataModel: DataModel) {
        self.dataModel = dataModel
        super.init()
    }
    
    
    func search(searchPhrase: String, completionHandler: @escaping ([Article]?, Error?) -> Void) {
        log.info()
        
        provider.request(.search(searchPhrase: searchPhrase, pageSize: searchPageSize)) { (moyaResult) in
            switch moyaResult {
            case .success(let result):
                let articles = self.handleArticleListResult(result)
                completionHandler(articles, nil)
                log.debug(articles)
            case .failure(let error):
                log.error(error)
                completionHandler(nil, error)
            }
            
        }
    
    }
    
    func loadCategories(completionHandler: @escaping () -> Void) {
        log.info()
        
        provider.request(.loadCategories) { (moyaResult) in
            switch moyaResult {
            case .success(let result):
                self.handleCategoriesResult(result)
            case .failure(let error):
                log.error(error)
            }
            completionHandler()
        }
    }
    
    func refreshArticlesList(_ categoryId: String, completionHandler: @escaping () -> Void) {
        log.info()
        var pageSize = defaultPageSize
        
        if let category = dataModel.categoriesDictionary[dataModel.selectedCategoryId],
            category.articles.count > 0 {
            pageSize = category.articles.count
        }
        provider.request(.refreshArticlesList(pageSize: pageSize, categoryId: categoryId)) { (moyaResult) in
            
            switch moyaResult {
            case .success(let result):
                let articles = self.handleArticleListResult(result)
                if articles.count > 0, var category = self.dataModel.categoriesDictionary[articles[0].sectionId] {
                    category.lastUpdate = Date()
                    category.articles = articles
                    self.dataModel.categoriesDictionary[articles[0].sectionId] = category
                }
            case .failure(let error):
                log.error(error)
            }
            completionHandler()
        }
    }

    func loadNextArticles(_ categoryId: String, completionHandler: @escaping () -> Void) {
        log.info()
        
        guard let category = dataModel.categoriesDictionary[dataModel.selectedCategoryId] else {
            log.warning("category for id \(categoryId) doesn't exist")
            completionHandler()
            return
        }

        let pageNumber = category.articles.count / defaultPageSize
        provider.request(.loadNextArticles(startPage: pageNumber + 1, pageSize: defaultPageSize, categoryId: categoryId)) { (moyaResult) in
            switch moyaResult {
            case .success(let result):
                let articles = self.handleArticleListResult(result)
                
                if articles.count > 0, var category = self.dataModel.categoriesDictionary[articles[0].sectionId] {
                    category.lastUpdate = Date()
                    category.articles += articles
                    self.dataModel.categoriesDictionary[articles[0].sectionId] = category
                }
            case .failure(let error):
                log.error(error)
            }
            completionHandler()
        }
    }
    
    func handleArticleListResult(_ result: Response) -> [Article] {
        switch result.statusCode {
        case HTTPStatusCode.success.rawValue:
            log.info("articlesList request status: \(result.statusCode)")
            let jsonData = JSON(result.data)
            log.info("**** articles")
            if let articlesListJSON = jsonData.dictionary?["response"]?["results"] {
                return dataModel.articlesFromJSON(jsonObject: articlesListJSON)
            } else {
                log.warning("invalid JSON data")
            }
        default:
            log.error("error: \(result.statusCode)")
        }
        return []
    }
    
    func handleCategoriesResult(_ result: Response) {
        switch result.statusCode {
        case HTTPStatusCode.success.rawValue:
            log.info("categories request status: \(result.statusCode)")
            let jsonData = JSON(result.data)
            log.debug("response JSON: \(jsonData)")
            
            if let categoriesListJSON = jsonData.dictionary?["response"]?["results"] {
                let parsedResults = dataModel.categoriesFromJSON(jsonObject: categoriesListJSON)
                dataModel.setCategories(categoriesArray: parsedResults)
            } else {
                log.warning("invalid JSON data")
            }
        default:
            log.error("error: \(result.statusCode)")
        }
    }
}
