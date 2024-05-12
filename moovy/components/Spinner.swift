//
//  Spinner.swift
//  moovy
//
//  Created by Anthony Gibah on 5/9/24.
//

import SwiftUI

struct Spinner: View {
  var body: some View {
      ZStack{
          ColorManager.backgroundColor
          ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: ColorManager.accentColor))
                .scaleEffect(2.0, anchor: .center) // Makes the spinner larger
                .onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Simulates a delay in content loading
                    // Perform transition to the next view here
                  }
                }
      }
    
  }
}

#Preview {
    Spinner()
}
