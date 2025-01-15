//
//  ContentView.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var viewModel: ColorPickerViewModel
    @State private var selectedFavoriteId: UUID? = nil
    
    var body: some View {
        HSplitView {
            // Left side: Color Grid and Hue Slider
            ColorGridView()
                .frame(minWidth: 400)
                .onTapGesture {
                    selectedFavoriteId = nil
                }
            
            // Right side: Color Values
          VStack {
            ColorValuesView()
              .frame(width: 300)
              .onTapGesture {
                  selectedFavoriteId = nil
              }
            
            // Favorites view
            FavoritesView(selectedFavoriteId: $selectedFavoriteId)            
          }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
        .environmentObject(ColorPickerViewModel())
}
