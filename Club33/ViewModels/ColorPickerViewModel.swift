//
//  ColorPickerViewModel.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

@MainActor
class ColorPickerViewModel: ObservableObject {
  @Published private(set) var colors: [[ColorValue]] = []
  @Published var selectedColor: ColorValue
  @Published var selectedHue: Double {
    didSet {
      if oldValue != selectedHue {
        generateColorGrid()
        updateSelectedColorForHue()
      }
    }
  }
  
  @AppStorage("lastSelectedHue") private var storedHue: Double = 125
  @AppStorage("lastSelectedSaturation") private var storedSaturation: Double = 100
  @AppStorage("lastSelectedBrightness") private var storedBrightness: Double = 100
  
  // Pre-computed values
  private let saturationValues = stride(from: 0, through: 100, by: 12.5).map { $0 }
  private let brightnessValues = stride(from: 100, through: 0, by: -12.5).map { $0 }
  
  init() {
    // First initialize the @Published properties
    let initialHue = UserDefaults.standard.double(forKey: "lastSelectedHue")
    let initialSaturation = UserDefaults.standard.double(forKey: "lastSelectedSaturation")
    let initialBrightness = UserDefaults.standard.double(forKey: "lastSelectedBrightness")
    
    let initialHSB = HSBColor(
      hue: initialHue != 0 ? initialHue : 125,
      saturation: initialSaturation != 0 ? initialSaturation : 100,
      brightness: initialBrightness != 0 ? initialBrightness : 100
    )
    
    self.selectedHue = initialHSB.hue
    self.selectedColor = ColorValue(hsb: initialHSB)
    
    generateColorGrid()
  }
  
  private func generateColorGrid() {
    var newColors: [[ColorValue]] = []
    
    for brightness in brightnessValues {
      var row: [ColorValue] = []
      for saturation in saturationValues {
        let hsb = HSBColor(
          hue: selectedHue,
          saturation: saturation,
          brightness: brightness
        )
        row.append(ColorValue(hsb: hsb))
      }
      newColors.append(row)
    }
    
    colors = newColors
  }
  
  private func updateSelectedColorForHue() {
    selectedColor = ColorValue(
      hsb: HSBColor(
        hue: selectedHue,
        saturation: selectedColor.hsb.saturation,
        brightness: selectedColor.hsb.brightness
      )
    )
  }
  
  func selectColor(_ color: ColorValue) {
    selectedColor = color
    selectedHue = color.hsb.hue
    storedHue = color.hsb.hue
    storedSaturation = color.hsb.saturation
    storedBrightness = color.hsb.brightness
  }
  
  func copyToClipboard() {
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(selectedColor.hexString, forType: .string)
  }
}
