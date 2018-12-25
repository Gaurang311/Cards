//
//  CommentScreen.swift
//  cards
//
//  Created by Gaurang Lathiya on 25/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit

class CommentScreen: UITableViewController {

    var arrComments: [Comments] = [Comments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Comments"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
}

// MARK: - UITableViewDataSource , UITableViewDelegate
extension CommentScreen {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrComments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CommentCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self)
            , for: indexPath) as? CommentCell {
            cell.commentsObj = self.arrComments[indexPath.row]
            return cell
        }
        return UITableViewCell.init()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
