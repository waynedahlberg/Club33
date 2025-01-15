//
//  ContentView.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ColorPickerViewModel
    
    var body: some View {
        HSplitView {
            // Left side: Color Grid and Hue Slider
            ColorGridView()
                .frame(minWidth: 400)
            
            // Right side: Color Values
            ColorValuesView()
                .frame(width: 300)
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(ColorPickerViewModel())
}
