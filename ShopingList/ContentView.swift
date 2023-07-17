//
//  ContentView.swift
//  ShopingList
//
//  Created by Marco Alonso Rodriguez on 17/07/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
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
                        
                        Spacer()
                        
                        if compra.comprado {
                            Text("Comprado")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                       
                    }///HStack
                }
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

}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
