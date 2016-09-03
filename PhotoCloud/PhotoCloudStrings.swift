//
//  PhotoCloudStrings.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

struct PhotoCloudStrings {
     static let APPNAME = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "PhotoCloud"
     static let APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
     static let COMMANDLINE_VERSION = "1.0.0"
     static let AcceptableFile = ["png","jpg","jpeg","gif","mp4","mov","zip","pdf","mp3"]
    
     static let QNURL = "http://www.7xptab.com1.z0.glb.clouddn.com/"
    
    //文件操作常量
    struct FileConstants {
        static func imageTempFilePath() -> String {
            var imageCacheTempFolder: String?
            if let cacheFolder = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
                imageCacheTempFolder = cacheFolder
            } else {
                imageCacheTempFolder = "~/temp"
            }
            imageCacheTempFolder  = imageCacheTempFolder! + "/PhotoCloudImageTemp"
            if !FileManager.default.fileExists(atPath: imageCacheTempFolder!) {
                try! FileManager.default.createDirectory(atPath: imageCacheTempFolder!, withIntermediateDirectories: true, attributes: nil)
            }
            return imageCacheTempFolder!
        }
        
        static func buildTempImagePath() -> String {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
            return buildTempImageCachePath(formatter.string(from: Date()) + ".png")
        }
        
        static func buildTempImageCachePath(_ imageName: String) -> String {
            return imageTempFilePath() + "/" + imageName
        }
    }
}

