//
//  Constants.swift
//  SwiftUiTest
//
//  Created by Евгений Сергеев on 13.04.2025.
//

import Foundation
import SwiftUICore

struct Constants {
    
    enum AppColors {
        case white
        case lightBlue
        case darkBlue
        case green
        case gray
        
        var color: Color {
            switch self {
            case .white:
                return Color(hex: "#FFFFFF")
            case .lightBlue:
                return Color(hex: "#52A3FF")
            case .darkBlue:
                return Color(hex: "#0A84FF")
            case .green:
                return Color(hex: "#2DC478")
            case .gray:
                return Color(hex: "#888995")
            }
        }
    }
}



