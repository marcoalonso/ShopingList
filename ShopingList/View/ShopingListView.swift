//
//  ContentView.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI
import CoreData
import PhotosUI

struct ShopingListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Compras.fecha, ascending: true)],
        animation: .default)
    private var compras: FetchedResults<Compras>
    
    static var fechaFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var fecha = Date()
    @State private var agregarArticulo = false

    var body: some View {
        NavigationView {
            List {
                ForEach(compras, id: \.id) { compra in
                    HStack {
                        Button {
                            compra.comprado.toggle()
                            try! self.viewContext.save()
                        } label: {
                            Image(systemName: compra.comprado ? "checkmark.rectangle.fill" : "rectangle")
                                .font(.headline.bold())
                                .foregroundColor(compra.comprado ? .green : .gray)
                        }
                        
                        VStack {
                            Text(compra.articulo ?? "")
                                .font(.headline.bold())
                                .foregroundColor(.primary)
                            
                            Text("\(compra.fecha ?? self.fecha, formatter: Self.fechaFormatter)")
                                .font(.caption)
                        }
                        .strikethrough(compra.comprado ? true : false)
                        
                        if let data = compra.imagen {
                            let imagenProducto = UIImage(data: data)
                            Image(uiImage: (imagenProducto ?? UIImage(named: "coffee"))!)
                                .resizable()
                                .frame(width: 50, height: 50, alignment: .center)
                        }
                        
                        Spacer()
                        
                        if compra.comprado {
                            Text("Comprado")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                       
                    }///HStack
                }.onDelete(perform: borrar)
            }
            
            .navigationTitle("ShopingList")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.agregarArticulo.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .sheet(isPresented: $agregarArticulo) {
                AgregarArticuloView().environment(\.managedObjectContext, self.viewContext)
            }
        }
    }

    func borrar(_ articulos: IndexSet) {
        for articulo in articulos {
            let articuloEliminar = compras[articulo]
            self.viewContext.delete(articuloEliminar)
        }
        do {
            try self.viewContext.save()
        } catch {
            print("Debug: error \(error.localizedDescription)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShopingListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
