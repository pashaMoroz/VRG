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

class WebViewController: UIViewController {
    
    var urlSite = ""
    var titleOfArticle = ""
    var imageOfArticle = ""
    var theBool: Bool = false
    var myTimer: Timer?
    var articles = [Articles]()
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate // Делегат класса AppDelegate
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var saveOutlet: UIBarButtonItem!
    @IBOutlet weak var navBarTitle: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        funcToCallWhenStartLoadingYourWebview()
        funcToCallCalledWhenUIWebViewFinishesLoading()
        timerCallback()
        let url = URL(string: urlSite)
        let request = URLRequest(url: url!)
        webView.load(request)
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
    
    func funcToCallWhenStartLoadingYourWebview() {
        self.progressView.progress = 0.0
        self.theBool = false
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector(("timerCallback")), userInfo: nil, repeats: true)
    }
    
    func funcToCallCalledWhenUIWebViewFinishesLoading() {
        self.theBool = true
    }
    
    @objc func timerCallback() {
        if self.theBool {
            if self.progressView.progress >= 1 {
                self.progressView.isHidden = true
                self.myTimer?.invalidate()
            } else {
                self.progressView.progress += 0.1
            }
        } else {
            self.progressView.progress += 0.05
            if self.progressView.progress >= 0.95 {
                self.progressView.progress = 0.95
            }
        }
    }
    
    @IBAction func backVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveArticle(_ sender: Any) {
        let managedContext = appDelegate.persistentContainer.viewContext // Создание объекта Managed Object Context
        guard let entity = NSEntityDescription.entity(forEntityName: "Articles", in: managedContext) else { return } // Создаение объекта сущности
        let article = NSManagedObject(entity: entity, insertInto: managedContext) as! Articles // Экземпляр модели Task
        // Присваиваем значение свойствам модели
        article.image = imageOfArticle
        article.title = titleOfArticle
        article.url = urlSite
        
        do {
            try managedContext.save()
            articles.append(article)
            saveOutlet.isEnabled = false
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    private func isSaveAvialeble() {
        for art in articles {
            if art.url == urlSite {
                saveOutlet.isEnabled = false
                return
            } else {
                saveOutlet.isEnabled = true
            }
        }
    }
    
}
