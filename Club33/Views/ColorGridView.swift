//
//  ColorGridView.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

struct ColorGridView: View {
    @EnvironmentObject private var viewModel: ColorPickerViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Grid(horizontalSpacing: 1, verticalSpacing: 1) {
                ForEach(viewModel.colors, id: \.self) { row in
                    GridRow {
                        ForEach(row) { color in
                            ColorSquare(color: color)
                        }
                    }
                }
            }
            .background(.secondary)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .aspectRatio(1, contentMode: .fit)
            
            HueSlider()
                .frame(height: 24)
        }
        .padding()
    }
}

struct ColorSquare: View {
    let color: ColorValue
    @EnvironmentObject private var viewModel: ColorPickerViewModel
    
    private var isSelected: Bool {
        viewModel.selectedColor.id == color.id
    }
    
    var body: some View {
        color.color
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(.white, lineWidth: 2)
                        .padding(2)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.selectColor(color)
            }
    }
}

struct HueSlider: View {
    @EnvironmentObject private var viewModel: ColorPickerViewModel
    @GestureState private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Hue gradient background
                LinearGradient(
                    colors: hueGradientColors(),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
                
                // Selector
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.white, lineWidth: 2)
                    .frame(width: 8, height: geometry.size.height + 4)
                    .position(
                        x: position(for: viewModel.selectedHue, in: geometry),
                        y: geometry.size.height/2
                    )
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isDragging) { _, state, _ in
                        state = true
                    }
                    .onChanged { value in
                        let hue = hue(from: value.location.x, in: geometry)
                        viewModel.selectedHue = HSBColor.snapHue(hue)
                    }
            )
        }
    }
    
    private func hueGradientColors() -> [Color] {
        stride(from: 0, through: 360, by: 30).map { hue in
            Color(hue: Double(hue)/360, saturation: 1, brightness: 1)
        }
    }
    
    private func position(for hue: Double, in geometry: GeometryProxy) -> CGFloat {
        geometry.size.width * CGFloat(hue/360)
    }
    
    private func hue(from position: CGFloat, in geometry: GeometryProxy) -> Double {
        Double(position / geometry.size.width * 360)
    }
}

#Preview {
    ColorGridView()
        .environmentObject(ColorPickerViewModel())
        .frame(width: 400)
        .padding()
}
