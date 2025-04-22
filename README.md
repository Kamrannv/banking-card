# Banking App

SwiftUI app simulating a simple banking card system. Users can create customers, create cards, and transfer funds between card accounts.

## Features

- **Create Customer** (name, surname, birth date, GSM)
- **Add 16-digit Cards**
- **Transfer Between Cards**
- Card preview with masked number, expiry, and CVV toggle
- Validation and error messaging

## Architecture

- **SwiftUI + Combine**
- **Clean Architecture**
- **MVI Pattern**: State, Event, ViewModel, View

## Testing

- **Unit Tests**: via `Swift Testing`
- **UI Tests**:
  - Page Object Pattern (AppRobot)
  
