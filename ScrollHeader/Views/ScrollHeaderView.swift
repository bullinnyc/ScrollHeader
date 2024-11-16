//
//  ScrollHeaderView.swift
//  ScrollHeader
//
//  Created by Dmitry Kononchuk on 16.11.2024.
//  Copyright © 2024 Dmitry Kononchuk. All rights reserved.
//

import SwiftUI

struct ScrollHeaderView<Header: View, Content: View>: View {
    // MARK: - Property Wrappers
    
    @State private var isShowHeader = true
    @State private var headerOffset: CGFloat = .zero
    @State private var turningPoint: CGFloat = .zero
    @State private var oldMinY: CGFloat = .zero
    @State private var orientation = UIDevice.current.orientation
    
    // MARK: - Private Properties
    
    private let header: () -> Header
    private let content: () -> Content
    private let threshold: UInt
    
    // MARK: - Initializers
    
    init(
        header: @escaping () -> Header,
        content: @escaping () -> Content,
        threshold: UInt = 0
    ) {
        self.header = header
        self.content = content
        self.threshold = threshold
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .top) {
            header()
                // Prevent into the safe area.
//                .padding(.top, 1)
                .sizeOfView { headerOffset = $0.height }
                .offset(
                    y: isShowHeader
                        ? .zero
                        : -headerOffset - UIWindow.safeAreaInsets.top
                )
            
            GeometryReader { geometry in
                let availableHeight = geometry.size.height
                let scrollSpaceIdentifier = "ScrollSpace"
                
                ScrollView(.vertical) {
                    content()
                        .background {
                            GeometryReader { geometry in
                                let contentHeight = geometry.size.height
                                
                                let headerMinY = geometry
                                    .frame(in: .named(scrollSpaceIdentifier))
                                    .minY
                                
                                let minY = max(
                                    min(.zero, headerMinY),
                                    availableHeight - contentHeight
                                )
                                
                                Color.clear
                                    .onChange(of: minY) { newValue in
                                        updateHeaderState(
                                            newValue: newValue,
                                            hysteresis: 1
                                        )
                                    }
                            }
                        }
                }
                .coordinateSpace(name: scrollSpaceIdentifier)
                // Prevent scrolling into the safe area.
//                .offset(y: isShowHeader ? headerOffset : 1)
                .offset(y: isShowHeader ? headerOffset : 0)
                .ignoresSafeArea(
                    edges: orientation.isLandscape ? .vertical : .horizontal
                )
            }
        }
        .animation(.easeInOut, value: isShowHeader)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
    }
    
    // MARK: - Private Methods
    
    private func updateHeaderState(newValue: CGFloat, hysteresis: UInt) {
        let maxHysteresis = max(hysteresis, 1)
        let thresholdWithHysteresis = CGFloat(threshold + maxHysteresis)
        
        if isShowHeader && turningPoint - newValue > thresholdWithHysteresis ||
            !isShowHeader && newValue - turningPoint > thresholdWithHysteresis {
            isShowHeader = newValue > turningPoint
        }
        
        if isShowHeader && newValue > oldMinY ||
            !isShowHeader && newValue < oldMinY {
            turningPoint = newValue
        }
        
        oldMinY = newValue
    }
}

// MARK: - Preview

#Preview {
    ScrollHeaderView(
        header: {
            Text("Header")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundStyle(.white)
                .background(.pink)
        },
        content: {
            VStack(spacing: .zero) {
                ForEach((1...100).reversed(), id: \.self) { number in
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
        },
        threshold: 0
    )
}
