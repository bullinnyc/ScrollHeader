//
//  DeviceRotationViewModifier.swift
//  ScrollHeader
//
//  Created by Dmitry Kononchuk on 16.11.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

private struct DeviceRotationViewModifier: ViewModifier {
    // MARK: - Public Properties
    
    let action: (UIDeviceOrientation) -> Void
    
    // MARK: - Private Properties
    
    private let orientationChanged = NotificationCenter.default
        .publisher(for: UIDevice.orientationDidChangeNotification)
    
    // MARK: - Body Method
    
    func body(content: Content) -> some View {
        content
            .onReceive(orientationChanged) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

// MARK: - Ext. View

extension View {
    func onRotate(
        perform action: @escaping (UIDeviceOrientation) -> Void
    ) -> some View {
        modifier(DeviceRotationViewModifier(action: action))
    }
}
