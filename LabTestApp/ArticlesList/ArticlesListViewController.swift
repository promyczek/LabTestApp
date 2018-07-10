//
//  ViewController.swift
//  LabTestApp
//
//  Created by Anna Zamora on 22/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController {

    // const
    let categoriesViewHeight = CGFloat(51.0)

    // properties
    
    let connectionManager: ConnectionManager
    let dataModel: DataModel
    let refreshControll: UIRefreshControl
    let categoriesViewController: CategoriesViewController
    let searchController = UISearchController(searchResultsController: nil)
    var tableHeaderViewHeightConstraint: NSLayoutConstraint?
    var collectionViewHeightConstraint: NSLayoutConstraint?
    var articlesList : [Article] = []
    
    // outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
    init(connectionManager: ConnectionManager, dataModel: DataModel, categoriesViewController: CategoriesViewController) {
        self.connectionManager = connectionManager
        self.dataModel = dataModel
        self.refreshControll = UIRefreshControl()
        self.refreshControll.tintColor = .green
        self.categoriesViewController = categoriesViewController
        super.init(nibName: "ArticlesListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        let cellNib = UINib(nibName: "ArticleViewCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: "cellId")
        self.refreshControll.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        categoriesViewController.delegate = self
        tableView.tableHeaderView = categoriesViewController.view
        
        categoriesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        tableHeaderViewHeightConstraint = categoriesViewController.view.heightAnchor.constraint(equalToConstant: categoriesViewHeight)
        tableHeaderViewHeightConstraint?.isActive = true
        categoriesViewController.view.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        categoriesViewController.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor).isActive = true
        categoriesViewController.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor).isActive = true
        categoriesViewController.view.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true

        categoriesViewController.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionViewHeightConstraint = categoriesViewController.collectionView?.heightAnchor.constraint(equalToConstant: categoriesViewHeight)
        collectionViewHeightConstraint?.isActive = true
        categoriesViewController.collectionView?.trailingAnchor.constraint(equalTo: categoriesViewController.view.trailingAnchor).isActive = true
        categoriesViewController.collectionView?.leadingAnchor.constraint(equalTo: categoriesViewController.view.leadingAnchor).isActive = true
        categoriesViewController.collectionView?.topAnchor.constraint(equalTo: categoriesViewController.view.topAnchor).isActive = true
        
        setCategoriesViewVisible(true)
        self.tableView.addSubview(self.refreshControll)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func refreshData() {
        connectionManager.refreshArticlesList(dataModel.selectedCategoryId, completionHandler: {
            self.refreshControll.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func setCategoriesViewVisible(_ visible: Bool) {
        if visible {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableHeaderViewHeightConstraint?.constant = self.categoriesViewHeight
                self.collectionViewHeightConstraint?.constant = self.categoriesViewHeight
                self.tableView.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.tableHeaderViewHeightConstraint?.constant = 0
                self.collectionViewHeightConstraint?.constant = 0
                self.tableView.layoutIfNeeded()
            })
        }
    }
}

extension ArticlesListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if scrollView.contentSize.height > scrollView.bounds.size.height && maximumOffset - contentOffset <= 60 {
//            connectionManager.loadNextArticles(dataModel.selectedCategoryId, completionHandler: {
//                self.tableView.reloadData()
//            })
        }
    }
}


extension ArticlesListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articlesList.isEmpty {
            tableView.separatorStyle = .none
        } else {
            tableView.separatorStyle = .singleLine
        }
        return articlesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? ArticleViewCell
        let article = articlesList[indexPath.row]
        cell!.titleLabel.text = article.title
        cell!.subtitleLabel.text = article.formattedDateString
        cell!.categoryLabel.text = article.sectionId
        return cell!
        
    }
}

extension ArticlesListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let article = dataModel.categoriesDictionary[dataModel.selectedCategoryId]!.articles[indexPath.row]
        let articleDetailViewController = container.resolve(ArticleDetailViewController.self, argument: article)!
        self.navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
}

extension ArticlesListViewController : CategoriesViewControllerDelegate {
    func didChangeCategory() {
        articlesList = dataModel.categoriesDictionary[dataModel.selectedCategoryId]?.articles ?? []
        tableView.reloadData()
    }
}

extension ArticlesListViewController : UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        log.info()
        setCategoriesViewVisible(false)
        articlesList = []
        tableView.reloadData()
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        log.info()
        articlesList = dataModel.categoriesDictionary[dataModel.selectedCategoryId]?.articles ?? []
        setCategoriesViewVisible(true)
        tableView.reloadData()
    }

}

extension ArticlesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchPhrase = searchController.searchBar.text, searchPhrase != "" else {
            return
        }
        
        connectionManager.search(searchPhrase: searchPhrase) {(articles, error) in
            if let articlesList = articles {
                self.articlesList = articlesList
                self.tableView.reloadData()
                log.debug(articlesList)
            } else if let err = error {
                log.error(err)
            }
        }
    }
}
