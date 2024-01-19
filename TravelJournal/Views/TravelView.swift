//
//  TravelView.swift
//  TravelJournal
//
//  Created by GradByte on 16.01.2024.
//

import SwiftUI
import PhotosUI

struct TravelView: View {
    @ObservedObject var travel: Travel
    @State var travelItem: TravelItem
    @Environment(\.dismiss) var dismiss
    @State private var country = ""
    @State private var city = ""
    @State private var type = ""
    @State private var editType = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    var types = ["Business", "Personal"]
    
    var body: some View {
        Form {
            Section {
                if editType == false {
                    if let imageData = travelItem.photo, 
                    let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    if let selectedPhotoData,
                    let image = UIImage(data: selectedPhotoData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Label("Select a photo", systemImage: "photo")
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                selectedPhotoData = data
                            }
                        }
                    }
                }
            }
            Section {
                if editType == false {
                    Text("\(travelItem.country)")
                    Text("\(travelItem.city)")
                    Text("\(travelItem.type)")
                } else {
                    TextField("\(travelItem.country)", text: $country)
                    TextField("\(travelItem.city)", text: $city)
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .onAppear() {
                        self.type = travelItem.type
                    }
                }
                
            }   header: {
                Text("Information")
            }
        }
        .toolbar {
            if editType == false {
                Button {
                    self.country = self.travelItem.country
                    self.city = self.travelItem.city
                    self.type = self.travelItem.type
                    self.selectedPhotoData = self.travelItem.photo
                    self.editType.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            } else {
                Button {
                    let index = travel.items.firstIndex {$0.id == travelItem.id} ?? 0
                    travel.items[index].country = country
                    travel.items[index].city = city
                    travel.items[index].type = type
                    travel.items[index].photo = selectedPhotoData
                    self.editType.toggle()
                    dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}
