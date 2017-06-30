//
//  File.swift
//  Pods
//
//  Created by Asakura Shinsuke on 2017/06/28.
//
//


public struct File {
    public enum FileType {
        case directory
        case file
        case unknown
    }
    /// Data
    public var data: Data? = nil
    /// File path.
    public var path: String? = nil
    
    /// File type
    /// directory or file.
    public var type: FileType {
        do {
            let info: NSDictionary = try FileManager.default.attributesOfItem(atPath: path!) as NSDictionary
            if FileAttributeType(rawValue: info.fileType()!) == FileAttributeType.typeDirectory {
                return .directory
            }
            return .file
        } catch {
            return .unknown
        }
    }
    
    /// Name of file
    public var name: String {
        return path!.components(separatedBy: "/").filter({ return !$0.isEmpty }).last ?? ""
    }
    
    
    /// Initialize with path.
    /// Data loading is automatic.
    ///
    /// - Parameter path: Path of file.
    /// - Throws: error when loading data.
    public init?(path: String) throws {
        self.path = path
        let info: NSDictionary = try FileManager.default.attributesOfItem(atPath: path) as NSDictionary
        if FileAttributeType(rawValue: info.fileType()!) != FileAttributeType.typeDirectory {
            guard let data = FileManager.default.contents(atPath: path) else {
                // TODO: Make correct error.
                throw NSError()
            }
            self.data = data
        }
    }
    
    /// Initialize with data.
    ///
    /// - Parameter data: data
    public init(data: Data) {
        self.data = data
    }
    
}
