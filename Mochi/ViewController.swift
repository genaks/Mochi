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
    
    var activeCellIndexPath : IndexPath?
    var goingInactiveCell = -1
    var lastContentOffset : CGFloat!
    
    var activeCellDict : [Int : Bool] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lastContentOffset = 0.0
        
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
    
    // MARK: Table view.

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
        if indexPath.row == 0 {
            activeCellDict[indexPath.row] = true
        }
        else {
            activeCellDict[indexPath.row] = false
        }
        cell.active = activeCellDict[indexPath.row]!
        return cell
    }
        
    // MARK: Scroll view.

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
            if activeCellIndexPath != indexPaths?[0]{
                activeCellIndexPath = indexPaths?[0]
            }
            if let cell = cells.last {
                self.playVideoForCell(cell: cell)
            }
        }
        else if cellCount >= 2 {
            for i in 0..<cellCount{
                
                if (self.lastContentOffset > scrollView.contentOffset.y) { //Scrolling up
                    if i == 0 { //Skip if it is the first visible cell
                        continue
                    }
                    else {
                        
                        let cellVisibleHeight = getVisibleHeightForCellAtIndexPath(indexPath: (indexPaths?[i - 1])!)
                        let cellHeight = (cells[i - 1] as AnyObject).frame.size.height
                        if cellVisibleHeight > (cellHeight * 0.5){
                            
                            if activeCellIndexPath != indexPaths?[i - 1]{
                                //Make incoming cell active
                                activeCellIndexPath = indexPaths?[i - 1]
                                self.playVideoForCell(cell: cells[i - 1])
                                cells[i - 1].active = true
                                
                                if goingInactiveCell != indexPaths?[i].row{
                                    //Make going out cell inactive
                                    goingInactiveCell = (indexPaths?[i].row)!
                                    self.pauseVideoOnCell(cell: cells[i])
                                    cells[i].active = false
                                }
                            }
                        }
                    }
                } else if (self.lastContentOffset < scrollView.contentOffset.y) { //Scrolling down
                    
                    if i == cellCount - 1 { //Skip if it is the last visible cell
                        continue
                    }
                    else {
                        let cellVisibleHeight = getVisibleHeightForCellAtIndexPath(indexPath: (indexPaths?[i + 1])!)
                        let cellHeight = (cells[i + 1] as AnyObject).frame.size.height
                        if cellVisibleHeight > (cellHeight * 0.5){
                            
                            if activeCellIndexPath != indexPaths?[i + 1]{
                                //Make incoming cell active
                                activeCellIndexPath = indexPaths?[i + 1]
                                self.playVideoForCell(cell: cells[i + 1])
                                cells[i + 1].active = true

                                if goingInactiveCell != indexPaths?[i].row{
                                    //Make going out cell inactive
                                    goingInactiveCell = (indexPaths?[i].row)!
                                    self.pauseVideoOnCell(cell: cells[i])
                                    cells[i].active = false
                                }
                            }
                        }
                    }
                }
                self.lastContentOffset = scrollView.contentOffset.y;
            }
        }
    }
    
    // MARK: Video controls.

    func playVideoForCell(cell : PostTableViewCell){
        cell.playVideo()
    }
    
    func pauseVideoOnCell(cell : PostTableViewCell){
        cell.stopVideo()
    }
    
    // MARK: Helpers.
    
    func getVisibleHeightForCellAtIndexPath(indexPath : IndexPath) -> CGFloat    {
        let cellRect = self.feedTableView.rectForRow(at: indexPath)
        let intersectRect = cellRect.intersection(self.feedTableView.bounds)
        let cellVisibleHeight = intersectRect.height
        return cellVisibleHeight
    }
}

