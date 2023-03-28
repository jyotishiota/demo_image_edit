//
//  ImageSaver.swift
//  test
//
//  Created by macOS on 7/2/20.
//  Copyright © 2020 PingAK9. All rights reserved.
//

import UIKit
import Combine

class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
            print("Oops: \(error.localizedDescription)")
        } else {
            successHandler?()
            print("Success!")
        }
    }
    
    func saveImageToDocumentDirectory(image: UIImage) {
        print("test")
        var objCBool: ObjCBool = true
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        print(mainPath)
        let folderPath = mainPath + "/Lol/"

        let isExist = FileManager.default.fileExists(atPath: folderPath, isDirectory: &objCBool)
        if !isExist {
            do {
                try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("error \(error)")
            }
        }

        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageName = "lol.png"
        let imageUrl = documentDirectory.appendingPathComponent("Lol/\(imageName)")
        if let data = image.jpegData(compressionQuality: 1.0){
            do {
                try data.write(to: imageUrl)
                print(" saving")
            } catch {
                print("error saving", error)
            }
        }
    }
}
