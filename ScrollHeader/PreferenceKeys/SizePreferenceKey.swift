//
//  SizePreferenceKey.swift
//  ScrollHeader
//
//  Created by Dmitry Kononchuk on 16.11.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - Ext. View

extension View {
    func sizeOfView(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(
                        key: SizePreferenceKey.self,
                        value: geometry.size
                    )
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
