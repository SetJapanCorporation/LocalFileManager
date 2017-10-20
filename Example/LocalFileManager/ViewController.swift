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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapedAdd(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let file = try! File(path: dirPath) {
            self.title = file.name
            reloadDatas()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController {
    func reloadDatas() {
        viewModel.loadFiles(directoryPath: dirPath) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            (view as! View).table.reloadData()
        }
    }
    
    @objc
    func didTapedAdd(sender: UIBarButtonItem) {
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
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
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return viewModel.files[indexPath.row].type == .file
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            rowAction, indexPath in
            let file = self.viewModel.files[indexPath.row]
            do {
                try LocalFileManager().delete(file)
                self.viewModel.files.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print(error)
            }
        }
        return [delAction]
    }
}

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        guard let data = UIImagePNGRepresentation(image) else { return }
        guard let url = info[UIImagePickerControllerReferenceURL] as? URL else { return }
        guard let imgId = url.dicFromQuery()["id"] else { return }
        var file = File(data: data)
        file.path = dirPath + "/" + imgId + ".png"
        print("Save for: \(String(describing: file.path))")
        do {
            try LocalFileManager().save(file)
        } catch {
            print(error)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension URL {
    func dicFromQuery() -> [String : String] {
        guard let queryString = self.absoluteString.components(separatedBy: "?").last else {
                return[:]
        }
        var result = [String : String]()
        queryString.components(separatedBy: "&").forEach() {
            query in
            let keyAndValue = query.components(separatedBy: "=")
            if keyAndValue.count == 2 {
                result[keyAndValue[0]] = keyAndValue[1]
            }
        }
        return result
    }
}
