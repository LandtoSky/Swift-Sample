//
//  PhotoUploader.swift
//  SweepBright
//
//  Created by Kaio Henrique on 6/15/16.
//  Copyright © 2016 madewithlove. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveCocoa
import Haneke

struct PhotoUploadProgress {
    var url: String?
    var image: UIImage?
    var progress: Double {
        return request?.progress.fractionCompleted ?? 0.0
    }
    var request: Alamofire.Request?

    /// Cancel upload
    func cancel() {
        self.request?.cancel()
    }

    func progressChanged() -> RACSignal? {
        return self.request?.progress.rac_valuesAndChangesForKeyPath("completedUnitCount", options: .New, observer: nil).deliverOnMainThread()
    }
}

class PhotoUploader: NSObject {
    static var queue: [PhotoUploadProgress] = []
    class func addProgress(progress: PhotoUploadProgress) {
        self.queue.append(progress)
    }
    class func getProgress(byUrl url: String) -> PhotoUploadProgress? {
        return self.queue.filter({$0.url == url && $0.progress < 1.0}).first
    }
    class func getProgress(byContact contact: CRMContact) -> PhotoUploadProgress? {
        let url = "\(SWBRoutes.SWBSERVERURL)/contacts/\(contact.id)/photo"
        return self.getProgress(byUrl: url)
    }
}

typealias CachedImage = UIImage? -> Void

class SWBImageCache: NSObject {
    private static var cache: NSCache = NSCache()
    private static var queue: NSOperationQueue = NSOperationQueue()

    private class ImageDownloadOperation: NSOperation {
        var url: NSURL!
        var images: [CachedImage?] = []

        init(url: NSURL) {
            self.url = url
        }

        private override func main() {
            var imageDownloaded: UIImage?
            if let data = NSData(contentsOfURL: url) {
                imageDownloaded = UIImage(data: data)
            }
            dispatch_async(dispatch_get_main_queue(), {
                for image in self.images {
                    image?(imageDownloaded)
                }
            })
        }
    }

    /**
     Update the image with the key identifier.

     - paremeter withKey: Identifier of the image in the cache
     */
    class func set(withKey key: String, image: UIImage) {
        Shared.imageCache.set(value: image, key: key)
    }

    /**
     Remove the image with the key identifier.

        - paremeter key: Identifier of the image in the cache
     */
    class func remove(withKey key: String) {
        Shared.imageCache.remove(key: key)
    }
    /**
     Delete the key, download the new image on the URL and update the cache

     - parameter url: Image's  URL
     */
    class func refresh(fromURL url: NSURL) {
        self.remove(withKey: url.absoluteString)
        self.updateImage(fromURL: url)
    }

    /**
     Re-download the image on the URL and update the cache.

     - parameter url: Image's  URL
     - returns: The new image
    */
    class func updateImage(fromURL url: NSURL, image: CachedImage? = nil) {
        self.getImage(fromURL: url, image: { imageFetched in
            if let imageFetched = imageFetched { self.set(withKey: url.absoluteString, image: imageFetched) }
            image?(imageFetched)
        })
    }
    /**
     Get the image with the key identifier from the cache system.
     The task runs async. If there is no such key on the cache and the key is an URL, it'll run the `updateImage` method.

     - paremeter key: Identifier of the image in the cache
     - paremeter image: Callback that will return the image after download it or immediately, if it's in cache.
     */
    class func get(withKey key: String, image: CachedImage) {
        Shared.imageCache.fetch(key: key).onSuccess(image).onFailure({ _ in
            if let url = NSURL(string: key) {
                self.updateImage(fromURL: url, image: image)
            }
        })
    }
    /**
     Get the image from URL.

     This will prevent a lot of request to the same URL.

     - parameter url: Image's  URL
     - returns: Image
     */
    private class func getImage(fromURL url: NSURL, image: CachedImage? = nil) {
        // Get operations to the url
        let imageDownloads = self.queue.operations.filter({ operation in
            if let operation = operation as? ImageDownloadOperation {
                return operation.url.absoluteString == url.absoluteString
            }
            return false
        }).map({$0 as! ImageDownloadOperation})

        //Add a image listener or create a new operation
        if let op: ImageDownloadOperation = imageDownloads.first {
            op.images.append(image)
        } else {
            let op = ImageDownloadOperation(url: url)
            op.images.append(image)
            self.queue.addOperation(op)
        }
    }

    /**
     Clear the cache.
     */
    class func clear() {
        Shared.imageCache.removeAll()
    }
}
