//
//  AgregarArticuloView.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI

struct AgregarArticuloView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var articulo: String = ""
    @Environment(\.presentationMode) var presentatioMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20.0) {
                
                Image("coffee")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
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
