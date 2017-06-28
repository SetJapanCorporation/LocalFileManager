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
    }
    
    public var data: Data? = nil
    public var path: String? = nil
    
    public var type: FileType {
        let info: NSDictionary = try! FileManager.default.attributesOfItem(atPath: path!) as NSDictionary
        if FileAttributeType(rawValue: info.fileType()!) == FileAttributeType.typeDirectory {
            return .directory
        }
        return .file
    }
    
    
    public var name: String {
        return path!.components(separatedBy: "/").filter({ return !$0.isEmpty }).last ?? ""
    }
    
    public init(path: String) throws {
        self.path = path
        let info: NSDictionary = try! FileManager.default.attributesOfItem(atPath: path) as NSDictionary
        if FileAttributeType(rawValue: info.fileType()!) != FileAttributeType.typeDirectory {
            guard let data = FileManager.default.contents(atPath: path) else {
                throw NSError()
            }
            self.data = data
        }
    }
    
    public init(data: Data) {
        self.data = data
    }

}
