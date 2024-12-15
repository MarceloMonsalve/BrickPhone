//
//  WallpaperPrompt.swift
//  BrickPhone
//
//  Created by Marcelo Monsalve on 12/14/24.
//


import SwiftUI
import UIKit

struct WallpaperPrompt: View {
    @State private var showingSaveAlert = false
    
    var body: some View {
        ZStack {
            Text("To make the widget and dock blend in please set ")
                .foregroundColor(.gray)
            + Text("this")
                .foregroundColor(.white)
                .underline()
            + Text(" image to be your wallpaper.")
                .foregroundColor(.gray)
        }
        .fixedSize(horizontal: false, vertical: true)
        .onTapGesture(perform: {
            showingSaveAlert = true
        })
        .alert("Add wallpaper to camera roll", isPresented: $showingSaveAlert) {
            Button("Yes") {
                saveImage()
            }
            Button("Cancel", role: .cancel) { }
        }
    }
    
    func saveImage() {
        guard let image = UIImage(named: "darkWallpaper") else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHandler = {
            print("Saved successfully")
        }
        
        imageSaver.errorHandler = { error in
            print("Error saving image: \(error.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: image)
    }
}
