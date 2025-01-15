//
//  Club33App.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

@main
struct ColorPickerApp: App {
  @StateObject private var viewModel = ColorPickerViewModel()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(viewModel)
    }
    .windowStyle(.titleBar)
    .windowResizability(.contentSize)
    .defaultSize(width: 800, height: 600)
    .defaultPosition(.center)
  }
}
