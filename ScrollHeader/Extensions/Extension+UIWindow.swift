//
//  Extension+UIWindow.swift
//  ScrollHeader
//
//  Created by Dmitry Kononchuk on 16.11.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

extension UIWindow {
    // MARK: - Public Properties
    
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        keyWindow?.safeAreaInsets ?? .zero
    }
}
