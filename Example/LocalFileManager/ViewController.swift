//
//  ViewController.swift
//  LocalFileManager
//
//  Created by asashin227 on 06/27/2017.
//  Copyright (c) 2017 asashin227. All rights reserved.
//

import UIKit
import LocalFileManager

class ViewController: UIViewController {    
    
    fileprivate let viewModel = ViewModel()
    var dirPath = try! LocalFileManager().absolutePath(.libraryDirectory)
    
    override func loadView() {
        let homeView = View(frame: UIScreen.main.bounds)
        homeView.table.dataSource = viewModel
        homeView.table.delegate = self
        
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let file = try! File(path: dirPath) {
            self.title = file.name
            viewModel.loadFiles(directoryPath: dirPath) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
                (view as! View).table.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selected(in: self, indexPath: indexPath)
    }
}
