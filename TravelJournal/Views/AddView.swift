//
//  AddView.swift
//  TravelJournal
//
//  Created by GradByte on 12.01.2024.
//

import SwiftUI
import PhotosUI

struct AddView: View {
    @ObservedObject var travel: Travel
    @Environment(\.dismiss) var dismiss
    
    @State private var country = ""
    @State private var city = ""
    @State private var type = "Personal"
    @State private var note = "Note"
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if let selectedPhotoData,
                       let image = UIImage(data: selectedPhotoData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select a photo", systemImage: "person")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedPhotoData = data
                            }
                        }
                    }
                }
                
                TextField("Country Name", text: $country)
                    .disableAutocorrection(true)
                
                TextField("City Name", text: $city)
                    .disableAutocorrection(true)
                
                Picker("Trip Type", selection: $type) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextEditor(text: $note)
                    .disableAutocorrection(true)
                
            }
            .navigationTitle("Add New Travel")
            .toolbar {
                Button("Add") {
                    let item = TravelItem(country: country, city: city, type: type, photo: selectedPhotoData, note: note)
                    travel.items.append(item)
                    dismiss()
                    
                }
                .disabled(country.isEmpty || city.isEmpty || selectedPhotoData == nil)
            }
        }
    }
}
