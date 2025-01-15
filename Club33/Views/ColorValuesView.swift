//
//  ColorValuesView.swift
//  Club33
//
//  Created by Wayne Dahlberg on 1/15/25.
//

import SwiftUI

struct ColorValuesView: View {
  @EnvironmentObject private var viewModel: ColorPickerViewModel
  @State private var showCopiedLabel: Bool = false
  
  let duration = 0.5
  
  
  var body: some View {
    VStack(spacing: 20) {
      // Color preview
      RoundedRectangle(cornerRadius: 8)
        .fill(viewModel.selectedColor.color)
        .frame(height: 100)
        .overlay(
          HStack {
            Image(systemName: "angle")
            Text("\(Int(viewModel.selectedColor.hsb.hue))")
          }
            .font(.system(size: 32, weight: .semibold, design: .rounded))
        )
        .padding()
      
      // Color values
      VStack(alignment: .leading, spacing: 24) {
        
        HStack(alignment: .center, spacing: 16) {
          Button {
            viewModel.copyToClipboard()
            showCopiedLabel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              withAnimation(.easeOut(duration: duration)) {
                showCopiedLabel = false
              }
            }
          } label: {
            Image(systemName: "doc.on.doc")
              .padding(.vertical, 6)
          }
          .buttonStyle(.bordered)
          colorSection("HSB") {
            HStack {
              Text("H: ").foregroundStyle(.tertiary)
              Text("\(Int(viewModel.selectedColor.hsb.hue))")
            }
            HStack {
              Text("S: ").foregroundStyle(.tertiary)
              Text("\(Int(viewModel.selectedColor.hsb.saturation))")
            }
            HStack {
              Text("B: ").foregroundStyle(.tertiary)
              Text("\(Int(viewModel.selectedColor.hsb.brightness))")
            }
          }
          
        }
        
        HStack(alignment: .center, spacing: 16) {
          Button {
            viewModel.copyToClipboard()
            showCopiedLabel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              withAnimation(.easeOut(duration: duration)) {
                showCopiedLabel = false
              }
            }
          } label: {
            Image(systemName: "doc.on.doc")
              .padding(.vertical, 6)
          }
          .buttonStyle(.bordered)
          
          colorSection("Hex") {
            HStack(spacing: 0) {
              Text("# ").foregroundStyle(.tertiary)
              Text("\(viewModel.selectedColor.hexString)")
                .textSelection(.enabled)
            }
          }
          
        }
      }
      .padding()
      
      Spacer()
      Text(showCopiedLabel ? "Copied to clipboard" : " ")
        .font(.system(size: 16))
        .monospaced()
        .foregroundStyle(.primary)
      
        .padding(.top)
    }
  }
  
  private func colorSection<Content: View>(
    _ title: String,
    @ViewBuilder content: () -> Content
  ) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title)
        .font(.headline)
      HStack {
        content()
          .monospaced()
        Spacer()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  private func copyHSB() {
    let hsb = viewModel.selectedColor.hsb
    let hsbString = "\(Int(hsb.hue)), \(Int(hsb.saturation)), \(Int(hsb.brightness))"
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(hsbString, forType: .string)
  }
}

#Preview {
  ColorValuesView()
    .environmentObject(ColorPickerViewModel())
    .frame(width: 300)
}
