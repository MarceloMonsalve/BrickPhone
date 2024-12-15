# Views/Components/RoundedBorderTextStyle.swift
import SwiftUI

struct RoundedBorderTextStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white)
            .cornerRadius(8)
    }
}