//
//  HomeScreen.swift
//  cards
//
//  Created by Gaurang Lathiya on 24/12/18.
//  Copyright © 2018 Gaurang Lathiya. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WebServiceFor {
    case PullToRefresh
    case Paging
    case FirstTime
}

class HomeScreen: UITableViewController {
    
    @IBOutlet var viewTableFooter: HomeScreenFooterView!
    
    var arrCards: [CardDetail] = [CardDetail]()
    var currentPageIndex: Int = 1
    var isDataLoading: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Home"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    // MARK: - Helper Methods
    func initUI()  {
        DispatchQueue.main.async {
            // Set TableFooter view frame
            self.viewTableFooter.frame = CGRect(x: 0, y: 0, width: Constants.SCREEN_SIZE.width, height: 40.0)
            self.tableView.tableFooterView = self.viewTableFooter
            self.viewTableFooter.activityIndicator.color = UIColor.black

            // Refresh Control
            self.tableView.addSubview(self.rfrshControl)
            // Call WEB API
            self.callWebAPI(webServiceFor: .FirstTime)
        }
    }
    
    // MARK: - Pull to refresh
    lazy var rfrshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
              action: #selector(self.handleRefresh(_:)),
              for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        currentPageIndex = 1 // makes it one.. and reload whole tableview
        self.callWebAPI(webServiceFor: .PullToRefresh)
    }
}

extension HomeScreen {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrCards.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell: CardImageCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CardImageCell.self)
                , for: indexPath) as? CardImageCell {
                cell.cardDetailObj = self.arrCards[indexPath.section]
                return cell
            }
        case 1:
            if let cell: CardDescriptionCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CardDescriptionCell.self)
                , for: indexPath) as? CardDescriptionCell {
                cell.cardDetailObj = self.arrCards[indexPath.section]
                return cell
            }
        case 2:
            if let cell: CardCommentsCountCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CardCommentsCountCell.self)
                , for: indexPath) as? CardCommentsCountCell {
                cell.cardDetailObj = self.arrCards[indexPath.section]
                return cell
            }
        default:
            break
        }
        return UITableViewCell.init()
     }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return Constants.SCREEN_SIZE.size.width - 10.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2:            
            if let commentScreenObj: CommentScreen = self.storyboard?
                .instantiateViewController(withIdentifier: String(describing: CommentScreen.self)) as? CommentScreen  {
                commentScreenObj.arrComments = self.arrCards[indexPath.section].comments ?? [Comments]()
                self.navigationController?.pushViewController(commentScreenObj, animated: true)
            }
        default:
            break
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((self.tableView.contentOffset.y + self.tableView.frame.size.height) >= self.tableView.contentSize.height)
        {
            if !isDataLoading{
                self.currentPageIndex += 1
                self.callWebAPI(webServiceFor: .Paging)
            }
        }
    }
}

// MARK: - WebService implementations
extension HomeScreen {
    
    // MARK: - Progress HUD Handler
    func startProgessHUD(webServiceFor: WebServiceFor) {
        
        isDataLoading = true
        
        if webServiceFor == .PullToRefresh {
            self.viewTableFooter.activityIndicator.stopAnimating()
            self.viewTableFooter.imgViewDot.isHidden = false
            return
        }
        self.viewTableFooter.activityIndicator.startAnimating()
        self.viewTableFooter.imgViewDot.isHidden = true
    }
    
    func stopProgessHUD(webServiceFor: WebServiceFor) {
        isDataLoading = false
        
        if webServiceFor == .PullToRefresh {
            return
        }
        self.viewTableFooter.activityIndicator.stopAnimating()
        self.viewTableFooter.imgViewDot.isHidden = false
    }
    
    // MARK: - Web API
    func callWebAPI(webServiceFor: WebServiceFor) {
        
        DispatchQueue.main.async {
            self.startProgessHUD(webServiceFor: webServiceFor)
        }
        
        let webAPIsessionObj: WebAPISession = WebAPISession()
        webAPIsessionObj.callWebAPI(wsType: .GET, webURLString: kWserviceUrl_GetCards, parameter: Dictionary<String, Any>()) { (response, error) in
            
            
            DispatchQueue.main.async {
                self.stopProgessHUD(webServiceFor: webServiceFor)
                self.rfrshControl.endRefreshing()
            }
            
            if let wsError = error {
                print("error: \(wsError)")
            } else {
                
                guard let jsonResponse = response?.dictionary else {
                    print("Response not in correct format")
                    return
                }
                
                let status: Bool = jsonResponse[Constants.kStatus]?.bool ?? false
                if status {
                    if let cardsArr = jsonResponse[Constants.kResponse]?.array, cardsArr.count > 0 {
                        
                        if webServiceFor != .Paging {
                            self.arrCards.removeAll()
                        }
                        
                        for card in cardsArr {
                            let cardDetailObj: CardDetail = CardDetail.init(json: card)
                            self.arrCards.append(cardDetailObj)
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        if self.arrCards.count == 0 {
                            DispatchQueue.main.async {
                                let message: String = "No cards available."
                                self.topMostViewController().showNavigationbarBanner(withTitle: Constants.kApplicationName, subtitle: message)
                            }
                        }
                    }
                } else {
                    let message: String = jsonResponse[Constants.kMessage]?.string ?? Constants.kErrorWebService
                    DispatchQueue.main.async {
                        self.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: message)
                    }
                }
            }
        }
    }
}
