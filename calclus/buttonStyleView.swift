//
//  buttonStyleView.swift
//  calclus
//
//  Created by Vivek on 10/10/26.
//

import SwiftUI

struct CalcButtonStyle: ButtonStyle {
    var bgColor: Color
    var fgColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 26, weight: .regular, design: .rounded))
            .foregroundColor(fgColor)
            .frame(maxWidth: .infinity, minHeight: 72)
            .background(bgColor)
            .cornerRadius(22)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
