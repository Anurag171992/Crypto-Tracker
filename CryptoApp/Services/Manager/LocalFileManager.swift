//
//  LocalFileManager.swift
//  CryptoApp
//
//  Created by Anurag on 09/08/26.
//

//Generic Local Manager to dave Images
import Foundation
import UIKit

class LocalFileManager {
    
    static let shared = LocalFileManager()
    private init() {}

    func saveImage(image: UIImage, ImageName: String, folderName: String ) {
        
        //Create folder
        createFolderAndGetFolderPathIfNeeded(folderName: folderName)
        
        //Get path for image
        guard let data = image.pngData(),
              let url = getURLforImage(ImageName: ImageName, folderName: folderName) else {return}
        
        //Save image to path
        do {
            try data.write(to: url)
        } catch {
            debugPrint("Error saving image: \(ImageName). \(error.localizedDescription)")
        }
        
    }
    
    //Get Actual Image
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLforImage(ImageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    //Creates a Folder If needed
    private func createFolderAndGetFolderPathIfNeeded(folderName: String) {
        guard let url = getURLforFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                debugPrint("Error creating folder: \(folderName): \(error.localizedDescription)")
            }
        }
    }
    
    //URL of the Folder
    private func getURLforFolder(folderName: String) -> URL? {
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let url else { return nil }
        return url.appendingPathComponent(folderName)
    }
    
    //Url of the Image inside the folder
    private func getURLforImage(ImageName: String, folderName: String) -> URL? {
        let folderURL = getURLforFolder(folderName: folderName)
        guard let folderURL else { return nil }
        return folderURL.appendingPathComponent(ImageName + ".png")
    }
}
