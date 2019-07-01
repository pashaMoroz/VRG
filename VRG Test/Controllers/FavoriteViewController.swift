//
//  FavoriteViewController.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/29/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var articles = [Articles]()
    
    @IBOutlet private  var tableView: UITableView!
    @IBOutlet private  var navBarTitle: UINavigationBar!
    @IBOutlet private  var tabBar: UITabBarItem!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate // Делегат класса AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarTitle.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        
        let managedContext = appDelegate.persistentContainer.viewContext // Создание объекта Managed Object Context
        let fetchRequest: NSFetchRequest<Articles> = Articles.fetchRequest() // Запрос выборки по ключу Task
        
        do {
            articles = try managedContext.fetch(fetchRequest) // Заполнение массива данными из базы
        } catch let error {
            print("Failed to fetch data", error)
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self)?.first as! TableViewCell
       
        let article = articles[indexPath.row]
        cell.configFavoriteCell(aricle: article)
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tabBar.tag {
        case 3:
            performSegue(withIdentifier: "showDetail", sender: nil)
        default:
            performSegue(withIdentifier: "showDetail", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! WebViewController
                detailVC.urlSite = articles[indexPath.row].url ?? ""
                detailVC.titleOfArticle = articles[indexPath.row].title ?? ""
                detailVC.imageOfArticle = articles[indexPath.row].title ?? ""
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let container = appDelegate.persistentContainer
            let commit = articles[indexPath.row]
            container.viewContext.delete(commit)
            articles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            appDelegate.saveContext()
        }
    }
    
}
