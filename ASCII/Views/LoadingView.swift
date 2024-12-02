//
//  LoadingView.swift
//  ASCII
//
//  Created by Raphael Iniesta Reis on 01/12/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            .scaleEffect(2.0, anchor: .center)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    
                }
            }
    }
}

#Preview {
    LoadingView()
}
