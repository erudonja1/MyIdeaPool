//
//  ListOfIdeasViewController.swift
//  MyIdeaPool
//
//  Created by Home Account on 6/4/19.
//  Copyright © 2019 Home Account. All rights reserved.
//

import Foundation
import UIKit

class ListOfIdeasViewController: BaseViewController, ListOfIdeasViewDelegate, IdeaTableViewProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet var noDataView: UIView!
    
    private var viewModel: ListOfIdeasViewModel = ListOfIdeasViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set data source
        tableView.dataSource = self
        tableView.delegate = self
        
        // register cells
        let ideaCell = UINib(nibName: "IdeaTableViewCell", bundle: nil)
        tableView.register(ideaCell, forCellReuseIdentifier: "IdeaTableViewCell")
        
        // custom setup for table
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        
        viewModel.delegate = self as ListOfIdeasViewDelegate
        viewModel.fetchIdeas()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        setNavigationWithLogout()
    }
    
    func setNavigationWithLogout(){
        setNavigation(withBackButton: false)
        
        // set logout option
        let logout = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(doLogout))
        navigationItem.rightBarButtonItems = [logout]
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let vc = UpdateIdeaViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func doLogout(){
        viewModel.logout()
    }
    
    private func showOptionsAlert(for idea: ApiIdea){
        let deleteAlert = UIAlertController(title: "Actions", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action: UIAlertAction) in
            let vc = UpdateIdeaViewController()
            vc.setModelData(idea: idea)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
            self.showQuestionAlert(for: idea)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        deleteAlert.addAction(editAction)
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        self.present(deleteAlert, animated: true, completion: nil)
    }
    
    private func showQuestionAlert(for idea: ApiIdea){
        let questionAlert = UIAlertController(title: "Are you sure?", message: "This idea will be permanently deleted", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            self.viewModel.deleteIdea(id: idea.id)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        questionAlert.addAction(okAction)
        questionAlert.addAction(cancelAction)
        
        present(questionAlert, animated: true, completion: nil)
    }
    
    // ListOfIdeasViewDelegate methods
    func logoutSucceeded() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func fetchedIdeas() {
        tableView.reloadData()
    }
    
    func deletedIdea() {
        viewModel.reset()
        viewModel.fetchIdeas()
    }
    
    func optionsTapped(for idea: ApiIdea) {
        showOptionsAlert(for: idea)
    }
}

extension ListOfIdeasViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ideas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == viewModel.ideas.count - 1 {
            viewModel.fetchNextPage()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaTableViewCell", for: indexPath) as? IdeaTableViewCell {
            let idea = viewModel.ideas[indexPath.row]
            cell.setup(with: idea, delegate: self as IdeaTableViewProtocol)
            return cell
        }
    
        return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        var numOfSections: Int = 0

        if viewModel.ideas.count > 0 {
            numOfSections = 1
            tableView.backgroundView = nil
        }else{
            numOfSections = 0
            tableView.backgroundView = noDataView
        }
        return numOfSections
    }
}
