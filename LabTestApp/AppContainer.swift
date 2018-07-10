//
//  AppContainer.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import Foundation
import UIKit
import Swinject

let appContainer = { () -> Container in
    let container = Container()
    
    container.register(DataModel.self) { _ in
        return DataModel()
    }.inObjectScope(.container)
    
    container.register(ConnectionManager.self) { r in
        let dataModel = r.resolve(DataModel.self)!
        return ConnectionManager(with: dataModel)
    }.inObjectScope(.container)
    
    container.register(ArticlesListViewController.self) { r in
        let dataModel = r.resolve(DataModel.self)!
        let connectionManager = r.resolve(ConnectionManager.self)!
        let categoriesViewController = r.resolve(CategoriesViewController.self)!
        return ArticlesListViewController(connectionManager: connectionManager, dataModel: dataModel, categoriesViewController: categoriesViewController)
    }.inObjectScope(.weak)
    
    container.register(NavigationController.self) { r in
        let rootViewController = r.resolve(ArticlesListViewController.self)!
        return NavigationController(rootViewController: rootViewController)
    }.inObjectScope(.container)
    
    container.register(CategoriesViewController.self, factory: { r in
        let dataModel = r.resolve(DataModel.self)!
        let connectionManager = r.resolve(ConnectionManager.self)!
        return CategoriesViewController(connectionManager: connectionManager, dataModel: dataModel)
    }).inObjectScope(.container)
    
    container.register(ArticleDetailViewController.self) {
        (r: Resolver, article: Article) in
        return ArticleDetailViewController(article)
    }
    
    return container
    
}
