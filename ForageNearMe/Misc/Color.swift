//
//  Color.swift
//  ForageNearMe
//
//  Created by Connor A Lynch on 28/10/2021.
//




import Foundation
import SwiftUI

extension Color {
    static let theme = Theme()
}

struct Theme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let cardBackground = Color("CardBackground")
    let navigationBackground = Color("NavigationBackground")
    let buttonBackgroundColor = Color("ButtonBackgroundColor")
}

