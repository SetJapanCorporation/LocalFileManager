//
//  LFMError.swift
//  Pods
//
//  Created by Asakura Shinsuke on 2017/07/03.
//
//


public enum LFMError: Error {
    /// Throw error when accessing an unauthorized place
    case permissionDenied
    /// File does not exist in path location
    case notFoundFileOrDirectory
    /// Path does not exist
    case blankPath
}
