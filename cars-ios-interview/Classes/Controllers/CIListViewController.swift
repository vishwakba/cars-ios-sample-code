//
//  CIListViewController.swift
//  cars-ios-interview
//
//  Created by Vishwak on 21/03/18.
//  Copyright © 2018 Vishwak. All rights reserved.
//

import UIKit
import SVProgressHUD

let KPagingCount: Int = 25
let queryString = "ipod"

class CIListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var list:[Any] = []
    
    var loadingStatus = false
    
    var currentPageNumber = 1

    @IBOutlet weak var errorLabel: UILabel!
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initFirstLoading { granted in
            if granted == true {
                self.contentTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initFirstLoading(_ completion: @escaping (Bool) -> Void) {
        SVProgressHUD.show(withStatus: "Fetching Details...")
        _ = CIAPIHandler.fetchContent(queryString, numOfItems: KPagingCount, offset: currentPageNumber) { (response, error) in
            if (response != nil) {
                SVProgressHUD.dismiss()
                //print("response: \(response!)")
                if let pageNumber = response!["start"] as? Int {
                    self.currentPageNumber = pageNumber
                    if let items:[Any] = response!["items"] as? [Any] {
                        //print("items: \(items)")
                        for obj in items {
                            let aObj: [String:Any]? = obj as? [String : Any]
                            if let responseObj = aObj {
                                self.list.append(responseObj)
                            }
                        }
                    }
                    debugPrint("list: \(self.list)")
                    completion(true)
                }
            } else if (error != nil) {
                //                print("error: \(error!)")
                self.errorLabel.isHidden = false
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                completion(true)
            }
        }
    }
    
    
    func loadMoreCompletion(_ completion: @escaping (Bool) -> Void) {
        
        if loadingStatus == true {
            return
        }
        
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: contentTableView.bounds.width, height: CGFloat(44))
        
        contentTableView.tableFooterView = spinner
        contentTableView.tableFooterView?.isHidden = false
        
        if loadingStatus == false {
            
            self.currentPageNumber = currentPageNumber + 1

            _ = CIAPIHandler.fetchContent(queryString, numOfItems: KPagingCount, offset: currentPageNumber) { (response, error) in
                if (response != nil) {
                    SVProgressHUD.dismiss()
                    //print("response: \(response!)")
                    
                    let numOfItems = response!["numItems"] as! Int

                    if let items:[Any] = response!["items"] as? [Any] {
                        //print("items: \(items)")
                        if numOfItems < KPagingCount {
                            self.loadingStatus = true
                        }
                        
                        for obj in items {
                            let aObj: [String:Any]? = obj as? [String : Any]
                            if let responseObj = aObj {
                                self.list.append(responseObj)
                            }
                        }
                    }
                    //debugPrint("list: \(self.list)")
                    completion(true)
                } else if (error != nil) {
                    //                print("error: \(error!)")
                    self.errorLabel.isHidden = false
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    completion(true)
                }
                
                self.contentTableView.tableFooterView = nil
                self.contentTableView.tableFooterView?.isHidden = true

            }
        }
    }
    
    // MARK: - UITableView Delegate & DataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CIDataCell", for: indexPath) as! CIDataCell
        cell.updateCellWithData(list[indexPath.row] as? [String : Any])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
            loadMoreCompletion({ granted in
                if granted == true {
                    self.contentTableView.reloadData()
                }
            })
        }
    }
}

