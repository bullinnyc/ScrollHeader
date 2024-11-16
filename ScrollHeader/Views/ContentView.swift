//
//  ContentView.swift
//  ScrollHeader
//
//  Created by Dmitry Kononchuk on 16.11.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Body
    
    var body: some View {
        ScrollHeaderView(
            header: {
                header
            },
            content: {
                VStack(spacing: .zero) {
                    ForEach((1...100).reversed(), id: \.self) { number in
                        row(number: number)
                    }
                }
            }
        )
    }
}

// MARK: - Ext. Configure views

extension ContentView {
    private var header: some View {
        Text("Header")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.white)
            .background(.pink)
    }
    
    private func row(number: Int) -> some View {
        Text("\(number)")
            .font(.subheadline)
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .foregroundStyle(.black)
            .background(.teal.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding([.leading, .trailing, .top], 8)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
