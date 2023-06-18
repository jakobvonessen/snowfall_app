Certainly! Here's a basic Markdown template for a `README.md` file for your app:

```
# Snowfall Comparison App

The Snowfall Comparison App is a mobile application that allows users to compare the total amount of snowfall between two cities. It helps users determine which place has the most livable snowfall based on data from the first of January 2020 to the 18th of June 2023.

## Features

- User-friendly interface for selecting two cities
- Query the Open-Meteo API to fetch hour-by-hour snowfall data
- Calculate and compare the total snowfall between the selected cities
- Present the city with the least snowfall as the most livable option

## Installation

To install and run the Snowfall Comparison App:

1. Clone the repository:

   ```shell
   git clone https://github.com/jakobvonessen/snowfall_app
   ```

2. Install the Flutter dependencies:

   ```shell
   flutter pub get
   ```

3. Run the app:

   ```shell
   flutter run
   ```

## Dependencies

The Snowfall Comparison App relies on the following dependencies:

- Flutter SDK
- Flutter packages:
  - `http` (for making HTTP requests)
  - `google_maps_flutter` (for accessing Google Maps Places API)

## Contributing

Contributions to the Snowfall Comparison App are welcome! If you encounter any issues or have suggestions for improvements, feel free to submit a pull request or open an issue in the repository and someone or something might take a look at that.