//
//  SettingsVC.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 4.06.24.
//

import UIKit

class SettingsVC: UIViewController {
     let tableView = UITableView()

     let aboutAppCell = "AboutAppCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        tableView.backgroundColor = .gray
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: aboutAppCell)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
    }
}
