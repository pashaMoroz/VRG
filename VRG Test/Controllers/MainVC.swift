//
//  ViewController.swift
//  VRG Test
//
//  Created by Pasha Moroz on 6/26/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import Alamofire

enum NytimesApi: String {
    case Emailed = "https://api.nytimes.com/svc/mostpopular/v2/emailed/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
    case Viewed = "https://api.nytimes.com/svc/mostpopular/v2/viewed/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
    case Shared = "https://api.nytimes.com/svc/mostpopular/v2/shared/30.json?api-key=qMfyAWPiUZdk691vvnsiDTAS2jgEQ0VF"
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var nytimes: Nytimes!
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tabBar: UITabBarItem!
    @IBOutlet private weak var activeIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var navBarTitle: UINavigationBar!
    
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
        let cell = Bundle.main.loadNibNamed("TableViewCell", owner: self)?.first as! TableViewCell
        
        
        
        guard let article = nytimes.results?[indexPath.row] else { return cell }
        guard let imageURL = article.media?.first?.mediaMetadata?.first?.url else { return cell }
        
        cell.config(imageURL, aricle: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch tabBar.tag {
        case 0:
            performSegue(withIdentifier: "showEmailed", sender: nil)
        case 1:
            performSegue(withIdentifier: "showViewed", sender: nil)
        case 2:
            performSegue(withIdentifier: "showShared", sender: nil)
        default:
            performSegue(withIdentifier: "showEmailed", sender: nil)
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
