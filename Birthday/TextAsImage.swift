//
//  TextAsImage.swift
//  Birthday
//
//  Created by Ефремов Олег on 08.04.2023.
//

import UIKit


/// Преобразование строки (не более двух символов) в UIImage
func imageWith(name: String?) -> UIImage? {
    let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    UIGraphicsBeginImageContext(frame.size)
    guard let context = UIGraphicsGetCurrentContext() else { return nil }
    let nameLabel = UILabel(frame: frame)
    nameLabel.textAlignment = .center
    nameLabel.backgroundColor = .gray
    nameLabel.textColor = .white
    nameLabel.font = UIFont.boldSystemFont(ofSize: 35)
    nameLabel.text = name
    nameLabel.layer.render(in: context)
    return UIGraphicsGetImageFromCurrentImageContext()
}

