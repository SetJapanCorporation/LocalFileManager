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
    public func absolutePath(_ targetDir: FileManager.SearchPathDirectory = .libraryDirectory, path: String = "") throws -> String {
        let dirNames = path.components(separatedBy: "/")
        guard let dir = NSSearchPathForDirectoriesInDomains(targetDir, .userDomainMask, true).first else {
            // TODO: Make correct error
            throw NSError()
        }
        if path.isEmpty {
            return dir
        }
        
        var path = dir
        
        let fileManager = FileManager.default
        try dirNames.forEachThrow() {
            dirName, breakLoop in
            if !dirName.isEmpty {
                path += "/" + dirName
                
                if dirNames.last == dirName && dirName.range(of: ".") != nil {
                    breakLoop()
                }
                
                if !fileManager.fileExists(atPath: path) {
                    try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
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
    
    /// Delete file
    ///
    /// - Parameter fullPath: path lfor data
    /// - Throws: error
    public func delete(_ file: File) throws {
        try FileManager.default.removeItem(atPath: file.path!)
    }
    
    /// Copy File
    ///
    /// - Parameters:
    ///   - file: target
    ///   - pathOfCopied: Copy destination path
    /// - Returns: Copied file
    /// - Throws: Error when saving file
    public func copy(_ file: File, to pathOfCopied: String) throws -> File? {
        var copy = File(data: file.data!)
        copy.path = pathOfCopied
        try save(copy)
        return copy
    }
    
    
    /// Retrieve all files under the path
    ///
    /// - Parameter path: Path
    /// - Returns: Files at path
    /// - Throws: Error when creating new object
    public func files(at path: String) throws -> [File]? {
        let list = try FileManager.default.contentsOfDirectory(atPath: path)
        
        var files = [File]()
        try list.forEachThrow() {
            filePath, breakLoop in
            do {
                if let file = try File(path: path + "/" + filePath) {
                    files.append(file)
                }
            } catch {
                throw error
            }
        }
        
        return files
    }
}


private extension Array {
    
    /// It is possible to return an error forEach.
    ///
    /// - Parameter operation: Operations on elements.
    /// - Throws: error
    func forEachThrow(operation: (Element, ()->Void) throws -> Void) rethrows {
        var breakLoop = false
        func breakFunction() {
            breakLoop = true
        }
        
        for item in self {
            try operation(item, breakFunction)
            if breakLoop {
                break
            }
        }
    }
}
