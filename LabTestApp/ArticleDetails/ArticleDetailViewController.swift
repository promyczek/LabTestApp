//
//  ArticleDetailViewController.swift
//  LabTestApp
//
//  Created by Anna Zamora on 27/02/2018.
//  Copyright © 2018 Anna Zamora. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    let article: Article
    
    init(_ article: Article) {
        self.article = article
        super.init(nibName: "ArticleDetailViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = URLRequest(url: URL(string: article.contentURL)!)
        webView.navigationDelegate = self
        webView.load(request)
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ArticleDetailViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.activityIndicatorHeightConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

