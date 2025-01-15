//
//  ColorModel.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

struct HSBColor: Hashable {
  let hue: Double        // 0-360
  let saturation: Double // 0-100
  let brightness: Double // 0-100
  
  init(hue: Double, saturation: Double, brightness: Double) {
    self.hue = Self.snapHue(hue)
    self.saturation = Self.snapComponent(saturation)
    self.brightness = Self.snapComponent(brightness)
  }
  
  static func snapHue(_ value: Double) -> Double {
    let snapped = round(value / 5) * 5
    return min(max(snapped, 0), 360)
  }
  
  static func snapComponent(_ value: Double) -> Double {
    let increment = 12.5
    let snapped = round(value / increment) * increment
    return min(max(snapped, 0), 100)
  }
  
  var color: Color {
    Color(hue: hue/360, saturation: saturation/100, brightness: brightness/100)
  }
}

struct ColorValue: Hashable, Identifiable {
  var id: String { hexString }
  let hsb: HSBColor
  
  var color: Color { hsb.color }
  
  var hexString: String {
    let nsColor = NSColor(hsb.color)
    guard let rgbColor = nsColor.usingColorSpace(.sRGB) else {
      return "000000"
    }
    
    return String(
      format: "%02X%02X%02X",
      Int(rgbColor.redComponent * 255),
      Int(rgbColor.greenComponent * 255),
      Int(rgbColor.blueComponent * 255)
    )
  }
}
