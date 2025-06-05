//
//  Unitily.swift
//  KhanMobileEffect
//
//  Created by Alikhan Tursunbekov on 5/6/25.
//
import UIKit

func convertCurrentDateToString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    return formatter.string(from: Date())
}
