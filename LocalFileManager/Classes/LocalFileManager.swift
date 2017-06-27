//
//  LocalFileManager.swift
//  LocalFileManagerDemo
//
//  Created by Asakura Shinsuke on 2017/06/27.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

import UIKit

public class LocalFileManager: NSObject {
    
    
    /// get absolute path
    ///
    /// - Parameters:
    ///   - targetDir: SearchPathDirectory.
    ///   - path: rerative path from targetDir.
    /// - Returns: Full path for rerative path
    func absolutePath(_ targetDir: FileManager.SearchPathDirectory = .libraryDirectory, path: String) throws -> String {
        let dirNames = path.components(separatedBy: "/")
        let dir = NSSearchPathForDirectoriesInDomains(targetDir, .userDomainMask, true).first
        var path = dir! + "/"
        
        try dirNames.forEachThrow() {
            dirName in
            path += dirName + "/"
            
            let fileManager = FileManager.default
            
            if !fileManager.fileExists(atPath: path) {
                do {
                    try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    throw error
                }
            }
        }
        return path
    }
    
    /// Save data for path
    ///
    /// - Parameters:
    ///   - data: data
    ///   - fullPath: Where you want to save
    /// - Throws: error
    func save(data: Data, fullPath: String) throws {
        try data.write(to: URL(fileURLWithPath: fullPath), options: .atomic)
        
    }
    
    /// Load file
    ///
    /// - Parameter fullPath: location of data
    /// - Returns: data
    /// - Throws: error
    func load(fullPath: String) throws -> Data! {
        let data: Data = try NSData.init(contentsOfFile: fullPath) as Data
        return data
    }
    
    /// Delete file
    ///
    /// - Parameter fullPath: path lfor data
    /// - Throws: error
    func deleteFile(fullPath: String) throws {
        try FileManager.default.removeItem(atPath: fullPath)
    }
}


private extension Array {
    func forEachThrow(operation: (Element) throws -> Void) rethrows {
        for item in self {
            try operation(item)
        }
    }
}
