//
//  ExploreView.swift
//  DallasWay
//
//  Created by Dharamvir Yadav on 8/23/24.
//

import SwiftUI
import MapKit

struct AnnotationItem: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}

struct ExploreView: View {
    
    @State private var selectedTab = 0
    @State private var selectedPlace: Place?
    @State private var viewModel = ExploreViewModel()
    
    var body: some View {
        
        VStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.places) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    Button(action: {
                        viewModel.fetchPlaceDetails(placeid: place.id) {
                            selectedPlace = place
                        }
                    }) {
                        VStack {
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 12, height: 30)
                                .foregroundColor(.red)
                                .onTapGesture {
                                    viewModel.fetchPlaceDetails(placeid: place.id) {
                                        selectedPlace = place
                                    }
                                }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .bottomSheet(presentationDetents: [.medium, .large], isPresented: .constant(true), sheetCornerRadius: 20, isTransparentBG: true) {
                ScrollView(.vertical, content: {
                    if selectedPlace != nil {
                        VStack {
                            // Segmented Control
                            Picker("Select Tab", selection: $selectedTab) {
                                Text("Images").tag(0)
                                Text("Tips").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.vertical)
                            
                            // Content based on selected segment
                            if selectedTab == 0 {
                                imagesList()
                            } else {
                                reviewsList()
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    } else {
                        VStack(spacing: 15) {
                            locationsList()
                        }
                        .padding()
                        .padding(.top)
                        .background {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()
                        }
                    }
                })
            } onDismiss: {}
        }
        .onAppear {
            viewModel.setupLocationManager()
        }
    }
    
    @ViewBuilder
    func locationsList() -> some View {
        VStack(spacing: 25) {
            ForEach(viewModel.places) { place in
                PlaceRowView(place: place)
                    .onTapGesture {
                        viewModel.fetchPlaceDetails(placeid: place.id) {
                            selectedPlace = place
                        }
                    }
            }
        }
        
        Spacer()
    }
    
    @ViewBuilder
    func imagesList() -> some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(viewModel.imageURLs, id: \.id) { imageURL in
                AsyncImage(url: URL(string: imageURL.url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Loading indicator while the image is fetched
                            .frame(height: 120)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .cornerRadius(10)
                            .clipped()
                    case .failure:
                        // Placeholder for failed images
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 120)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func reviewsList() -> some View {
        VStack(alignment: .leading, spacing: 25) {
            ForEach(viewModel.reviews, id: \.id) { review in
                Text(review.text)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Spacer()
    }
}

struct PlaceRowView: View {
    let place: Place

    var body: some View {
        HStack(alignment: .top) {
            
            VStack(alignment: .leading, spacing: 5) {
                Text(place.name)
                    .font(.headline)
                
                Text(place.location.formattedAddress)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {
                if let category = place.categories.first?.name {
                    Text(category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                if let distance = place.distanceFromUser {
                    Text(String(distance) + " mi")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ExploreView()
}
