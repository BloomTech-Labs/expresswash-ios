//
//  UIImage+cached.swift
//  ExpressWash
//
//  Created by Joel Groomer on 5/29/20.
//  Copyright © 2020 Bobby Keffury. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static var cache: [String: UIImage] = [:]

    // Use UIImage.cached to get an image you may want to download more than
    // once. The optional `defaultTitle` parameter takes a string representing
    // a named image in the application bundle.

    static func cached(from urlString: String, defaultTitle: String? = nil) -> UIImage? {
        var returnImage: UIImage?

        if !UIImage.cache.keys.contains(urlString) ||
            UIImage.cache[urlString] == nil {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    returnImage = UIImage(data: data)
                    UIImage.cache[urlString] = returnImage
                    print("Downloaded and cached image for \(urlString)")
                } else {
                    returnImage = UIImage(named: defaultTitle ?? "")
                }
            } else {
                returnImage = UIImage(named: defaultTitle ?? "")
            }
        } else {
            returnImage = UIImage.cache[urlString]
            print("Using cached image for \(urlString)")
        }

        return returnImage
    }

    static func cached(from url: URL, defaultTitle: String? = nil) -> UIImage? {
        cached(from: url.absoluteString, defaultTitle: defaultTitle)
    }

    static func refreshCache(for urlString: String) {
        UIImage.cache[urlString] = nil  // clear out the stored image
        _ = cached(from: urlString)     // request it again from server
    }

    static func refreshCache(for url: URL) {
        refreshCache(for: url.absoluteString)
    }
}
