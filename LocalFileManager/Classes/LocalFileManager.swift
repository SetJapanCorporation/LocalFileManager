//
//  LocalFileManager.swift
//  LocalFileManagerDemo
//
//  Created by Asakura Shinsuke on 2017/06/27.
//  Copyright © 2017年 Asakura Shinsuke. All rights reserved.
//

public class LocalFileManager: NSObject {
    
    /// get absolute path and creteDirectory when not found the directory
    ///
    /// - Parameters:
    ///   - targetDir: SearchPathDirectory.
    ///   - path: rerative path from targetDir.
    /// - Returns: Full path for rerative path
    public func absolutePath(_ targetDir: FileManager.SearchPathDirectory = .libraryDirectory, path: String) throws -> String {
        let dirNames = path.components(separatedBy: "/")
        let dir = NSSearchPathForDirectoriesInDomains(targetDir, .userDomainMask, true).first
        var path = dir! + "/"
        
        try dirNames.forEachThrow() {
            dirName in
            if !dirName.isEmpty {
                if dirName.range(of: ".") == nil && dirNames.last != dirName {
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
                else {
                    path += dirName
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
    public func save(_ file: File) throws {
        try file.data?.write(to: URL(fileURLWithPath: file.path!), options: .atomic)
        
    }
    
    /// Load file
    ///
    /// - Parameter fullPath: location of data
    /// - Returns: data
    /// - Throws: error
    public func load(path: String) throws -> File! {
        let file = try File(path: path)
        return file
    }
    
    /// Delete file
    ///
    /// - Parameter fullPath: path lfor data
    /// - Throws: error
    public func delete(_ file: File) throws {
        try FileManager.default.removeItem(atPath: file.path!)
    }
    
    public func copy(_ file: File, to pathOfCopied: String) throws -> File? {
        var copy = File(data: file.data!)
        copy.path = pathOfCopied
        try save(copy)
        return copy
    }
    
    public func files(at path: String) throws -> [File]? {
        let list = try! FileManager.default.contentsOfDirectory(atPath: path)
        
        var files = [File]()
        try list.forEachThrow() {
            filePath in
            do {
                try files.append(File(path: path + filePath))
            } catch {
                throw error
            }
        }
        
        return files
    }
}


private extension Array {
    func forEachThrow(operation: (Element) throws -> Void) rethrows {
        for item in self {
            try operation(item)
        }
    }
}
