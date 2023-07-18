//
//  UploadPostViewModel.swift
//  Instagram
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI
import PhotosUI

@MainActor
class SelectImageViewModel: ObservableObject {
    
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage)} }
    }
    @Published var profileImage: Image?
    @Published var productImage: UIImage?
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.productImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
}
