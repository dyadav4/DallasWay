//
//  ExploreViewModel.swift
//  Dallaspere
//
//  Created by Dharamvir Yadav on 8/23/24.
//

import SwiftUI
import MapKit

@Observable
class ExploreViewModel {
    var selectedTab = 0
    var reviews: PlaceTips = []
    var imageURLs: PlaceImages = []
    var exploreSheetState: SheetPlacesState = .loading
    var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 32.779167, longitude: -96.808891), latitudinalMeters: 100000, longitudinalMeters: 100000)
    
    var places: [Place] = [] {
        didSet {
            let coordinates = places.map { $0.coordinate }
            setRegionForCoordinates(coordinates)
        }
    }
    
    var selectedPlace: Place? {
        didSet {
            if let selectedPlace {
                updateRegion(to: selectedPlace.coordinate)
            } else {
                let coordinates = places.map { $0.coordinate }
                setRegionForCoordinates(coordinates)
            }
        }
    }
    
    @ObservationIgnored private var userLocation: CLLocation?
    
    private let service = ExplorerAPIService()
    private let locationManager = LocationManager()
    
    func setupLocationManager() {
        locationManager.userLocationHandler = { [weak self] location in
            guard let self = self else { return }
            self.userLocation = location
            self.fetchPlaces()
        }
        
        locationManager.locationErrorHandler = { [weak self] error in
            guard let self = self else { return }
            self.fetchPlaces()
        }
        
        locationManager.startUpdatingLocation()
    }
    
    private func fetchPlaces() {
        exploreSheetState = .loading
        
        service.fetchPlaces() { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    self?.exploreSheetState = .error
                    return
                }
                
                switch result {
                case .success(let fetchedPlaces):
                    guard let places = fetchedPlaces?.results else {
                        exploreSheetState = .error
                        return
                    }
                    
                    if places.isEmpty {
                        exploreSheetState = .empty
                        return
                    }
                    
                    exploreSheetState = .data
                    sortPlaces(of: places)
                case .failure:
                    exploreSheetState = .error
                }
            }
        }
    }
    
    func fetchPlaceDetails(placeid: String, completion: @escaping () -> Void) {
        exploreSheetState = .loading
        
        let dispatchGroup = DispatchGroup() // Create a DispatchGroup to synchronize tasks

        var fetchedImages: PlaceImages = []
        var fetchedTips: PlaceTips = []

        // Fetch images
        dispatchGroup.enter()
        fetchImages(placeid: placeid) { result in
            switch result {
            case .success(let images):
                fetchedImages = images ?? []
            case .failure:
                break
            }
            dispatchGroup.leave()
        }

        // Fetch tips
        dispatchGroup.enter()
        fetchTips(placeid: placeid) { result in
            switch result {
            case .success(let tips):
                fetchedTips = tips ?? []
            case .failure:
                break
            }
            dispatchGroup.leave()
        }

        // Notify when all tasks are complete
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.exploreSheetState = .data
            self.sortImages(images: &fetchedImages)
            self.sortTips(tips: &fetchedTips)
            completion()
        }
    }

    // MARK: - Separate Fetch Methods

    private func fetchImages(placeid: String, completion: @escaping (Result<PlaceImages?, Error>) -> Void) {
        service.fetchPlaceImages(placeid: placeid) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    private func fetchTips(placeid: String, completion: @escaping (Result<PlaceTips?, Error>) -> Void) {
        service.fetchPlaceTips(placeid: placeid) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func setRegionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) {
        guard !coordinates.isEmpty else { return }
        
        // Calculate the bounding box
        let minLat = coordinates.map { $0.latitude }.min() ?? 0.0
        let maxLat = coordinates.map { $0.latitude }.max() ?? 0.0
        let minLon = coordinates.map { $0.longitude }.min() ?? 0.0
        let maxLon = coordinates.map { $0.longitude }.max() ?? 0.0
        
        // Expand the bounding box slightly for padding
        let latDelta = (maxLat - minLat) * 1.2
        let lonDelta = (maxLon - minLon) * 1.2
        
        let centerLat = (minLat + maxLat) / 2
        let centerLon = (minLon + maxLon) / 2
        
        let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        region = MKCoordinateRegion(center: center, span: span)
    }
    
    private func sortPlaces(of places: [Place]) {
        
        guard let userLocation else {
            self.places = places
            return
        }
        
        var updatesPlaces = [Place]()
        for place in places {
            var newPlace = place
            newPlace.distanceFromUser = calculateDistanceInMiles(from: place.coordinate.toCLLocation(), to: userLocation)
            updatesPlaces.append(newPlace)
        }
        
        updatesPlaces.sort {
            ($0.distanceFromUser ?? Double.greatestFiniteMagnitude) < ($1.distanceFromUser ?? Double.greatestFiniteMagnitude)
        }
        
        self.places = updatesPlaces
    }
    
    private func sortImages( images: inout PlaceImages) {
        images.sort(by: { $0.createdAt < $1.createdAt })
        self.imageURLs = images
        
    }
    
    private func sortTips(tips: inout PlaceTips) {
        tips.sort(by: { $0.createdAt < $1.createdAt })
        self.reviews = tips
    }
    
    private func calculateDistanceInMiles(from location1: CLLocation, to location2: CLLocation) -> Double {
        let distanceInMeters = location1.distance(from: location2) // Distance in meters
        let distanceInMiles = distanceInMeters / 1609.344 // Convert meters to miles
        return distanceInMiles.rounded(toPlaces: 2)
    }
    
    private func updateRegion(to coordinate: CLLocationCoordinate2D) {
        withAnimation {
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
    }
    
    func openAppleMaps(to coordinate: CLLocationCoordinate2D) {
        let destination  = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        let options: [String: Any] = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        destination.openInMaps(launchOptions: options)
    }
}

enum SheetPlacesState {
    case loading
    case error
    case empty
    case data
}
