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

final class MainVC: UIViewController {
    
    var nytimes: Nytimes!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var articles = [Articles]()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tabBar: UITabBarItem!
    @IBOutlet private weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navBarTitle: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        activeIndicator.startAnimating()
        activeIndicator.hidesWhenStopped = true
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupViewWillAppear()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! WebViewController
        if segue.identifier == "showEmailed" || segue.identifier == "showViewed" || segue.identifier == "showShared" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.websiteAddress = nytimes.results?[indexPath.row].url ?? ""
                detailVC.titleOfWebsite = nytimes.results?[indexPath.row].title ?? ""
                detailVC.imageOfWebsite = nytimes.results?[indexPath.row].media?.first?.mediaMetadata?.first?.url ?? ""
            }
        }
        if segue.identifier == "showDetail" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                
                detailVC.websiteAddress = articles[indexPath.row].url ?? ""
                detailVC.titleOfWebsite = articles[indexPath.row].title ?? ""
                detailVC.imageOfWebsite = articles[indexPath.row].title ?? ""
            }
        }
    }
    
    private func setupNavigationBar() {
        navBarTitle.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20)!]
    }
    
    private func setupViewWillAppear() {
        if self.restorationIdentifier ==  "myFavorite" {
            
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
            
            NetworkManager.fetchDataWithAlamofire(url: chooseUrl()) { (nytimes) in
                self.nytimes = nytimes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activeIndicator.stopAnimating()
                }
            }
        }
    }
    
}

extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.restorationIdentifier ==  "myFavorite" {
            
            return articles.count
        } else {
            
            return nytimes?.results?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self)?.first as! TableViewCell
        
        if self.restorationIdentifier == "myFavorite" {
            
            let article = articles[indexPath.row]
            cell.configFavoriteCell(aricle: article)
        } else {
            guard let article = nytimes.results?[indexPath.row] else { return cell }
            guard let imageURL = article.media?.first?.mediaMetadata?.first?.url else { return cell }
            cell.config(imageURL, aricle: article)
        }
        
        return cell
    }
    
}

extension MainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tabBar.tag {
        case 0:
            performSegue(withIdentifier: "showEmailed", sender: nil)
        case 1:
            performSegue(withIdentifier: "showViewed", sender: nil)
        case 2:
            performSegue(withIdentifier: "showShared", sender: nil)
        case 3:
            performSegue(withIdentifier: "showDetail", sender: nil)
        default:
            performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    private func chooseUrl() -> String {
        
        switch tabBar.tag {
        case 0:
            return NytimesApi.Emailed.rawValue
        case 1:
            return  NytimesApi.Viewed.rawValue
        case 2:
            return  NytimesApi.Shared.rawValue
        default:
            return  NytimesApi.Shared.rawValue
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete && self.restorationIdentifier ==  "myFavorite" {
            let container = appDelegate.persistentContainer
            let commit = articles[indexPath.row]
            container.viewContext.delete(commit)
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            appDelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.restorationIdentifier ==  "myFavorite" {
            return true
        } else {
            return false
        }
    }
}
