//
//  QiniuProvider.swift
//  PhotoCloud
//
//  Created by liupeng on 18/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation

public class QiniuProvider: UploadProtocol {
    
    public static let instance = QiniuProvider()
    
    public func uploadFile(fileUrl:NSURL) {
        //init qnConfig
        LogProvider.writeLogFile("uploadFile: " + fileUrl.absoluteString)
        guard let config = Preferences.SharedPreferences().currentQNAccountConfig else {
            // need set pref
            LogProvider.writeLogFile("uploadFile: error not config account")
            NotifyHelper.showNotify("请先配置七牛账户信息")
            return
        }
        
        let qx =  Qiniu.init(QNURL: PhotoCloudStrings.QNURL, withQNBucketName: config.Bucket, withQNAccessKey: config.Access_Key, withQNSecretKey: config.Secret_Key)
        let token = qx.upToken()
        let upManager = QNUploadManager.init(configuration: QNConfiguration.build({ (build) in
            build.chunkSize =  4 * 1024 * 1024
        }))
        let uploadOption = QNUploadOption.init(mime: "", progressHandler: { (key, percent) in
            NSLog("uploading file: %@ percent: %@", key ?? "",percent)
            }, params: nil, checkCrc: true, cancellationSignal: nil)
        var fileName = fileUrl.lastPathComponent
        if let name = fileName where !Preferences.SharedPreferences().filePrefix.isEmpty  {
            fileName = Preferences.SharedPreferences().filePrefix + "_" + name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        }
        upManager.putFile(fileUrl.path, key: fileName, token: token, complete: { (info, key, resp) in
            if (resp == nil) {
                NSLog("upload fail %@", info.error.description)
                LogProvider.writeLogFile("uploadFile: complete error: " + info.error.description)
                NotifyHelper.showNotify( "文件上传失败了伙计",desc: info.error.description)
                return
            }
            NSLog("upload success: %@", key ?? "")
            LogProvider.writeLogFile("uploadFile: success: key: " + (key ?? ""))
            var fileName:String = ""
            if let userPutfileName = key {
                fileName = userPutfileName
            } else {
                fileName = resp.first!.1 as! String
            }
            let remoteUrl = "\(config.WebUrl!)/\(fileName)"
            NSLog("upload remote url: %@", remoteUrl)
            LogProvider.writeLogFile("uploadFile: success: remoteUrl:  " + remoteUrl)
            let pasteBoard = NSPasteboard.generalPasteboard()
            pasteBoard.declareTypes([NSStringPboardType], owner: nil)
            pasteBoard.setString(remoteUrl, forType: NSStringPboardType)
            NotifyHelper.showNotify( "文件上传成功\(fileName)",desc: remoteUrl)
            PhotoCloudStoreProvider.SharedPhotoCloudStore().addItem(PhotoCloudItemModel(fileName: fileName,downloadUrl: remoteUrl))
            }, option: uploadOption)
    }
    
}