//
//  PhotoCloudStoreProvider.swift
//  PhotoCloud
//
//  Created by liupeng on 19/08/2016.
//  Copyright © 2016 liupeng. All rights reserved.
//

import Foundation
import RealmSwift

private let _SharedStore = PhotoCloudStoreProvider();

class PhotoCloudStoreProvider {
    
    class func SharedPhotoCloudStore() -> PhotoCloudStoreProvider {
        return _SharedStore
    }
    
    let realm = try! Realm()
    
    /// - Warning: can only be used from the main thread
    var photoCloudItemList: Results<PhotoCloudItemModel> {
        return realm.objects(PhotoCloudItemModel.self).sorted(sortDescriptorsForPhotoCloudList)
    }
    
    /// Orders the PhotoCloudItemModel by createTime (descending)
    lazy var sortDescriptorsForPhotoCloudList: [SortDescriptor] = [SortDescriptor(property: "createTime", ascending: false)]

    /// save item
    func addItem(item: Object) {
        let backgroundRealm = try! Realm()
        backgroundRealm.beginWrite()
        backgroundRealm.add(item, update: true)
        try!  backgroundRealm.commitWrite()
    }

}