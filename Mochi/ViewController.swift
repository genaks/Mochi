//
//  ViewController.swift
//  Mochi
//
//  Created by Akshay Jain on 11/12/2019.
//  Copyright © 2019 Akshay Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    var posts : Array<Post>?
    
    var visibleCellIndexPath : IndexPath?
    var scrollingOutCell = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImageView = UIImageView.init(image: UIImage(named: "Mochi"))
        self.navigationItem.titleView = titleImageView
        
        if let path = Bundle.main.path(forResource: "document", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                    posts = Post.modelsFromDictionaryArray(array: jsonResult["posts"] as! NSArray)
                    feedTableView.reloadData()
                }
            } catch {
                
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.feedTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        cell.configureCellForPost(post: posts![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostTableViewCell {
            postCell.playVideo()
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let postCell = cell as? PostTableViewCell {
            postCell.stopVideo()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexPaths = feedTableView.indexPathsForVisibleRows
        var cells = [PostTableViewCell]()
        for indexPath in indexPaths!{
            if let cell = self.feedTableView.cellForRow(at: indexPath) as? PostTableViewCell {
                cells.append(cell)
            }
        }
        let cellCount = cells.count
        if cellCount == 0 {return}
        else if cellCount == 1 {
            if visibleCellIndexPath != indexPaths?[0]{
                visibleCellIndexPath = indexPaths?[0]
            }
            if let cell = cells.last {
                self.playVideoForCell(cell: cell)
            }
        }
        else if cellCount >= 2 {
            for i in 0..<cellCount{
                let cellRect = self.feedTableView.rectForRow(at: (indexPaths?[i])!)
                let intersectRect = cellRect.intersection(self.feedTableView.bounds)
                let cellVisibleHeight = intersectRect.height
                let cellHeight = (cells[i] as AnyObject).frame.size.height
                if cellVisibleHeight > (cellHeight * 0.5){
                    if visibleCellIndexPath != indexPaths?[i]{
                        visibleCellIndexPath = indexPaths?[i]
                        self.playVideoForCell(cell: cells[i])
                    }
                }
                else{
                    if scrollingOutCell != indexPaths?[i].row{
                        scrollingOutCell = (indexPaths?[i].row)!
                        self.pauseVideoOnCell(cell: cells[i])
                    }
                }
            }
        }
    }
    
    func playVideoForCell(cell : PostTableViewCell){
        cell.playVideo()
    }
    
    func pauseVideoOnCell(cell : PostTableViewCell){
        cell.stopVideo()
    }
}

