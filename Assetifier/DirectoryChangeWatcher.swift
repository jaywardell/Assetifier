//
//  DirectoryChangeWatcher.swift
//  Assetifier
//
//  Created by Joseph A. Wardell on 5/26/20.
//  Copyright © 2020 Joseph A. Wardell. All rights reserved.
//

import Foundation
import Combine


final class DirectoryChangeWatcher : NSObject {
    lazy var presentedItemOperationQueue = OperationQueue.main
    var presentedItemURL: URL? { directoryURL }
    
    let directoryURL : URL
    
    let didChange = PassthroughSubject<URL, Never>()
    
    init(directoryURL:URL) {
        self.directoryURL = directoryURL
        
        super.init()
        
        NSFileCoordinator.addFilePresenter(self)
    }
    
    deinit {
        NSFileCoordinator.removeFilePresenter(self)
    }
}

extension DirectoryChangeWatcher : NSFilePresenter {
        
    func presentedItemDidChange() {
        didChange.send(directoryURL)
    }
}


