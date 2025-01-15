//
//  FavoritesView.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

// Your imports remain the same

struct FavoritesView: View {
  @EnvironmentObject private var viewModel: ColorPickerViewModel
  @AppStorage("favoriteColors") private var favoritesData: Data = Data()
  @State private var favorites: [FavoriteColor] = []
  @Binding var selectedFavoriteId: UUID?
  
  private let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 8)
  private let maxFavorites = 24
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("Favorites")
          .font(.headline)
        
        Spacer()
        
        HStack(spacing: 8) {          
          Button {
            removeFavorite()
          } label: {
            Image(systemName: "minus")
          }
          .buttonStyle(.borderless)

          Button {
            addFavorite()
          } label: {
            Image(systemName: "plus")
          }
          .buttonStyle(.borderless)
        }
      }
      .padding(.horizontal)
      
      LazyVGrid(columns: columns, spacing: 4) {
        ForEach(Array(0..<maxFavorites), id: \.self) { index in
          if index < favorites.count {
            let favorite = favorites[index]
            FavoriteColorCell(favorite: favorite, isSelected: selectedFavoriteId == favorite.id)
              .frame(height: 24)
              .onTapGesture {
                // Update selected favorite and view model
                selectedFavoriteId = favorite.id
                viewModel.selectFavoriteColor(favorite)
                copyToClipboard(favorite)
              }
          } else {
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.secondary.opacity(0.1))
              .frame(height: 24)
              .overlay(
                RoundedRectangle(cornerRadius: 4)
                  .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
              )
          }
        }
      }
      .padding(.horizontal)
    }
    .padding(.bottom, 16)
    .onAppear(perform: loadFavorites)
  }
  
  // Helper functions remain the same
  
  
  // FavoriteColorCell remains the same
  
  // Preview remains the same
  
  private func loadFavorites() {
    guard !favoritesData.isEmpty else { return }
    if let decoded = try? JSONDecoder().decode([FavoriteColor].self, from: favoritesData) {
      favorites = decoded
    }
  }
  
  private func saveFavorites() {
    if let encoded = try? JSONEncoder().encode(favorites) {
      favoritesData = encoded
    }
  }
  
  private func addFavorite() {
    let newFavorite = FavoriteColor(from: viewModel.selectedColor)
    
    if favorites.count < maxFavorites {
      // Add new favorite if under max capacity
      favorites.append(newFavorite)
    } else {
      // Replace selected favorite or last one if none selected
      if let selectedId = selectedFavoriteId,
         let index = favorites.firstIndex(where: { $0.id == selectedId }) {
        favorites[index] = newFavorite
      } else {
        favorites[maxFavorites - 1] = newFavorite
      }
    }
    saveFavorites()
  }
  
  private func removeFavorite() {
    guard let selectedId = selectedFavoriteId,
          let index = favorites.firstIndex(where: { $0.id == selectedId }) else { return }
    favorites.remove(at: index)
    selectedFavoriteId = nil
    saveFavorites()
  }
  
  private func copyToClipboard(_ favorite: FavoriteColor) {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(favorite.hexString, forType: .string)
  }
}

struct FavoriteColorCell: View {
  let favorite: FavoriteColor
  let isSelected: Bool
  
  var body: some View {
    favorite.color
      .clipShape(RoundedRectangle(cornerRadius: 4))
      .overlay(
        RoundedRectangle(cornerRadius: 4)
          .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
      )
  }
}
