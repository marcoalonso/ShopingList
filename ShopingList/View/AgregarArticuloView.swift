//
//  AgregarArticuloView.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI
import Photos

struct AgregarArticuloView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var articulo: String = ""
    @Environment(\.presentationMode) var presentatioMode
    @State private var imagePickerPresented = false
    @StateObject var viewModel = SelectImageViewModel()

    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                
                if let image = viewModel.profileImage {
                    image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .onTapGesture {
                        imagePickerPresented.toggle()
                    }
                } else {
                    Image("coffee")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                        .onTapGesture {
                            imagePickerPresented.toggle()
                        }
                }
                    
                
                TextField("Articulo", text: $articulo)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                
                Button {
                    let nuevoArticulo = Compras(context: self.viewContext)
                    nuevoArticulo.id = UUID()
                    nuevoArticulo.articulo = self.articulo
                    nuevoArticulo.comprado = false
                    nuevoArticulo.fecha = Date()
                    
                    if let imageToSave = viewModel.productImage {
                        let data = imageToSave.jpegData(compressionQuality: 1.0)
                        nuevoArticulo.imagen = data
                    } else {
                        nuevoArticulo.imagen = UIImage(named: "coffee")?.pngData() //Image("coffee")
                    }
                    
                    
                    do {
                        try self.viewContext.save()
                    } catch {
                        print("Debug: error \(error.localizedDescription)")
                    }
                    
                    presentatioMode.wrappedValue.dismiss()
                } label: {
                    Text("Agregar".uppercased())
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .padding(8)
                        .background(self.articulo.count > 0 ? .blue : .gray)
                        .cornerRadius(12)
                        .shadow(radius: 12)
                }
                .disabled(self.articulo.count > 0 ? false : true)
                
                
                Spacer()

            }
            .photosPicker(isPresented: $imagePickerPresented, selection: $viewModel.selectedImage)
            .padding(.horizontal)
            .navigationTitle("Agregar Articulos")
        }
    }
}

struct AgregarArticuloView_Previews: PreviewProvider {
    static var previews: some View {
        AgregarArticuloView()
    }
}
