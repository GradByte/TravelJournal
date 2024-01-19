//
//  ContentView.swift
//  TravelJournal
//
//  Created by GradByte on 12.01.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var travels = Travel()
    @State private var showingAddTravel = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(travels.items, id: \.id) { item in
                        NavigationLink {
                            TravelView(travel: travels, travelItem: item)
                                .navigationTitle("\(item.country)")
                        } label: {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("\(item.country)")
                                        .font(.headline)
                                    Spacer()
                                    Text("\(item.city)")
                                        .font(.headline)
                                    Spacer()
                                    Text("\(item.type)")
                                        .font(.subheadline)
                                }
                                .padding()
                                Spacer()
                                if let imageData = item.photo,
                                let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 120)
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    .onDelete(perform: removeItems)
                } header: {
                    Text("Places")
                }
            }
            .navigationTitle("Travel Journal")
            .toolbar {
                Button {
                    showingAddTravel = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTravel) {
                AddView(travel: travels)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        travels.items.remove(atOffsets: offsets)
    }
    
}

#Preview {
    ContentView()
}
