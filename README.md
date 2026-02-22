# DallasWay

An iOS application that helps users discover and explore nearby attractions in Dallas using their current location. Built with SwiftUI and MVVM architecture.

## Features

- **Location-Based Discovery** - Automatically finds attractions near your current location
- **Interactive Map** - MapKit integration with custom annotations for places of interest
- **Place Details** - Tap on map pins to view detailed information about each location
- **Real-time Data** - Fetches live data about nearby attractions using location services
- **Bottom Sheet UI** - Modern, iOS-native bottom sheet interface for place details

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture for clean separation of concerns:

```
DallasWay/
├── Explore/
│   ├── Model/          # Data models (PlacesResponse, PlaceImages)
│   ├── View/           # SwiftUI views (ExploreView)
│   ├── ViewModel/      # Business logic (ExploreViewModel)
│   └── WebService/     # API services (ExplorerAPIService)
├── Events/             # Events module
├── Jobs/               # Jobs module
├── News/               # News module
└── Extensions/         # Helper extensions
```

## Tech Stack

- **Language**: Swift
- **Framework**: SwiftUI
- **Architecture**: MVVM
- **Maps**: MapKit
- **Location**: CoreLocation
- **Minimum iOS Version**: iOS 14.0+

## Privacy

The app requests location permissions to provide nearby attraction recommendations. Location data is used only for displaying relevant places and is not stored or shared. See [Privacy Policy](https://dyadav4.github.io/DallasWay/) for details.

## Installation

1. Clone the repository
```bash
git clone https://github.com/dyadav4/DallasWay.git
```

2. Open the project in Xcode
```bash
cd DallasWay
open DallasWay.xcodeproj
```

3. Build and run on simulator or device (requires location permissions)

## Modules

- **Explore** - Main feature for discovering nearby attractions
- **Events** - Local events and activities (in development)
- **Jobs** - Job listings in the area (in development)
- **News** - Local news updates (in development)

## Contributing

This is a personal project, but suggestions and feedback are welcome!

## License

[Add your license here]

## Contact

- GitHub: [@dyadav4](https://github.com/dyadav4)
- Email: dharam.yadav91@gmail.com
