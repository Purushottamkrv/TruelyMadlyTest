//
//  KExtension.swift
//  iOS Contact List
//
//  Created by Purushottam on 14/01/21.
//  Copyright © 2021 Purushottam. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textfield = getTextField() else { return }
                  textfield.textColor = .darkGray
            textfield.backgroundColor = .white
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10
                backgroundview.clipsToBounds = true
        
    }
    }
    
}

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}


extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}

extension UIView {
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.masksToBounds = true
    }
    
    func borderOfView()  {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = true
    }
    
    func cornerRadiusOfView()  {
          self.layer.cornerRadius = 10
          self.clipsToBounds = true
      }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

