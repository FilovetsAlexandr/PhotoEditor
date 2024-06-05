//
//  SettingsVCExtension.swift
//  PhotoEditor
//
//  Created by Alexandr Filovets on 5.06.24.
//

import UIKit

extension SettingsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: aboutAppCell, for: indexPath)
        cell.textLabel?.text = "About App"
        cell.textLabel?.textColor = .tabBarItemAccent
        cell.accessoryType = .disclosureIndicator
        cell.layer.cornerRadius = 16
              cell.clipsToBounds = true
        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "About the Photo Editor", message: "This app was created \n by Alexandr Filovets.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        okButton.setValue(UIColor.tabBarItemAccent, forKey: "titleTextColor")

        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
