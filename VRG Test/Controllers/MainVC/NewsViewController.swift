//
//  ViewController.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/26/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


//class BasePResenter {
//    
//    var view: BVc
//    
//    func viewDidLoad() { }
//}
//
//class BVc: UIViewController {
//    
//    var presenter: BasePResenter?
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        presenter.viewDidLoad()
//    }
//}
//
//protocol NewsViewProtocol {
//    
//    func update(withNews: [News])
//}
//
//
//class NewsPresenter: BasePResenter {
//    
//    override func viewDidLoad() {
//        
//        super.viewDidLoad()
//        
//        Network.loadData { [weak self] data in
//            
//            (self?.view as? NewsViewProtocol)?.update(withNews: data)
//        }
//    }
//}

protocol ArticleProtocol {
    
    var title: String? { get }
    var url: String? { get }
    var imageURL: String? { get }
}

final class NewsViewController: UIViewController {
    
    var newsType: NewsType?
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var articles = [ArticleProtocol]()
    
    @IBOutlet private weak var tabBar: UITabBarItem!
    #warning("Move to base")
    @IBOutlet private weak var navBarTitle: UINavigationBar!
    @IBOutlet private weak var tableView: UITableView!
    #warning("Move to base")
    @IBOutlet private weak var activeIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UINib(nibName: String(describing: TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableViewCell.self))
        
        tableView.delegate = self
        tableView.dataSource = self
        activeIndicator.startAnimating()
        activeIndicator.hidesWhenStopped = true
        title = newsType?.nameOfTitle
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupViewWillAppear()
   }
    
    
    private func setupViewWillAppear() {
        #warning("Move to Presenter")
        if newsType == .favorite {
            
            let managedContext = appDelegate.persistentContainer.viewContext // Создание объекта Managed Object Context
            let fetchRequest: NSFetchRequest<Articles> = Articles.fetchRequest() // Запрос выборки по ключу Task
            do {
                articles = try managedContext.fetch(fetchRequest) // Заполнение массива данными из базы
            } catch let error {
                print("Failed to fetch data", error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activeIndicator.stopAnimating()
            }
            
        } else {
            if let newsType = newsType {
                
                NetworkManager.fetchDataWithAlamofire(url: newsType.path()) { [weak self] (nytimes) in
                    self?.articles = nytimes.results ?? []
                    //self.nytimes = nytimes
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                        self?.activeIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

extension NewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        #warning("Complare wirth typer")
        guard let title = newsType?.nameOfTitle else {
            
            return 0
        }
        
        #warning("TODO - remove when move ti the protocol")
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        #warning("Reuse")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TableViewCell.self)) as? TableViewCell else { return UITableViewCell() }
        
        let article = articles[indexPath.row]
        cell.configFavoriteCell(aricle: article as! ArticleProtocol)

        return cell
    }
    
}

extension NewsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var webViewVC: WebViewController!
        if  webViewVC == nil {
            webViewVC = WebViewController()
            webViewVC.newsViewController = self
            
            #warning("TODO - protcol")
            webViewVC.websiteAddress = articles[indexPath.row].url ?? ""
            webViewVC.titleOfWebsite = articles[indexPath.row].title ?? ""
            webViewVC.imageOfWebsite = articles[indexPath.row].imageURL ?? ""
            
        }
        self.navigationController?.pushViewController(webViewVC, animated: true)
        
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let title = newsType?.nameOfTitle else {
            
            return
        }
        
        if editingStyle == .delete && title == NewsType.favorite.rawValue  {
            #warning("PResenter")
            let container = appDelegate.persistentContainer
            let commit = articles[indexPath.row]
            container.viewContext.delete(commit as! NSManagedObject)
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        #warning("compare with type")
        guard let title = newsType?.nameOfTitle else {
            
            return false
        }
        
        if title == NewsType.favorite.rawValue  {
            
            return true
        } else {
            return false
        }
    }
   
}

extension Articles: ArticleProtocol {
    
}
