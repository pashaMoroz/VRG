//
//  ViewController.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/26/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire


class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nytimes: Nytimes!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navBarTitle: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeIndicator.startAnimating()
        activeIndicator.hidesWhenStopped = true
        navBarTitle.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "American Typewriter", size: 20)!]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NetworkManager.fetchDataWithAlamofire(url: chooseUrl()) { (nytimes) in
            self.nytimes = nytimes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.activeIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nytimes?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emailedCell", for: indexPath) as! TableViewCell
        
        guard let article = nytimes.results?[indexPath.row] else { return cell }
        guard let imageURL = article.media?.first?.mediaMetadata?.first?.url else { return cell}
        
        cell.config(imageURL, aricle: article)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func chooseUrl() -> String {
        
        switch tabBar.tag {
        case 0:
            return "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
        case 1:
            return  "https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
        case 2:
            return  "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
        default:
            return  "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEmailed" || segue.identifier == "showViewed" || segue.identifier == "showShared" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! WebViewController
                detailVC.urlSite = nytimes.results?[indexPath.row].url ?? ""
                detailVC.titleOfArticle = nytimes.results?[indexPath.row].title ?? ""
                detailVC.imageOfArticle = nytimes.results?[indexPath.row].media?.first?.mediaMetadata?.first?.url ?? ""
            }
        }
    }
    
}
