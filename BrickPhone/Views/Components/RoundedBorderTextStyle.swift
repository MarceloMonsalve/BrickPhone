//
//  RoundedBorderTextStyle.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/12/24.
//


import SwiftUI

struct RoundedBorderTextStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}
