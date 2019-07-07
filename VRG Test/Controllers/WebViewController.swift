//
//  WebViewController.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/28/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import WebKit
import CoreData

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var websiteAddress: String = ""
    var titleOfWebsite: String = ""
    var imageOfWebsite: String = ""
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate // Делегат класса AppDelegate
    
    private var webPageLoaded: Bool = false
    private var pageLoadTimer: Timer?
    private var articles = [Articles]()
   
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var saveButtonOutlet: UIBarButtonItem!
    @IBOutlet private weak var navigationBarTitle: UINavigationBar!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDisplayWebView()
        loadWebView()
        addActivityIndToWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let managedContext = appDelegate.persistentContainer.viewContext // Создание объекта Managed Object Context
        let fetchRequest: NSFetchRequest<Articles> = Articles.fetchRequest() // Запрос выборки по ключу Task
        do {
            articles = try managedContext.fetch(fetchRequest) // Заполнение массива данными из базы
            isSaveAvialeble()
        } catch let error {
            print("Failed to fetch data", error)
        }
    }
    
    @IBAction func backVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveArticle(_ sender: Any) {
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Articles", in: managedContext) else { return }
        let article = NSManagedObject(entity: entity, insertInto: managedContext) as! Articles
        article.image = imageOfWebsite
        article.title = titleOfWebsite
        article.url = websiteAddress
        do {
            try managedContext.save()
            articles.append(article)
            saveButtonOutlet.isEnabled = false
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    private func isSaveAvialeble() {
        for art in articles {
            if art.url == websiteAddress {
                
                saveButtonOutlet.isEnabled = false
                return
            } else {
                
                saveButtonOutlet.isEnabled = true
            }
        }
    }
    
    private func loadWebView() {
        guard let url = URL(string: websiteAddress) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupDisplayWebView() {
        webView = WKWebView(frame: view.frame)
        webView.frame =  CGRect(x: 0 , y: self.view.frame.height * 0.1, width: self.view.frame.width, height: self.view.frame.height)
        webView.navigationDelegate = self
        view.addSubview(webView)
        view.addSubview(navigationBarTitle)
    }
    
    private func addActivityIndToWebView() {
        webView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
}


