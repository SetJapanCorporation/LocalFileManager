//
//  ViewModel.swift
//  LocalFileManager
//
//  Created by Asakura Shinsuke on 2017/06/28.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import LocalFileManager

class ViewModel: NSObject {
    // Cell's ID
    let cellId = "CellId"
    // Showing file
    var files = [File]()
    
    ///  Load files
    ///
    /// - Parameters:
    ///   - directoryPath: path
    ///   - compleation: didFinished load
    func loadFiles(directoryPath: String, compleation: (Error?)->Void) {
        do {
            files = try LocalFileManager().files(at: directoryPath) ?? []
            compleation(nil)
        } catch {
            compleation(error)
        }
    }
    
    /// When selected tableView cell
    ///
    /// - Parameters:
    ///   - viewController: Current viewcontroller
    ///   - indexPath: Selected indexPath
    func selected(in viewController: UIViewController, indexPath: IndexPath) {
        let file = files[indexPath.row]
        if file.type == .directory {
            let next = ViewController()
            next.dirPath = file.path!
            viewController.navigationController?.pushViewController(next, animated: true)
        }
    }
}

extension ViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return files[indexPath.row].type == .file
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId);
        let file = files[indexPath.row]
        
        cell.textLabel?.text = file.name
        cell.detailTextLabel?.text = file.type == .file ? "File" : "Directory"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
}
