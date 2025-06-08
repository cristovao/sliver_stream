# SliverStream Example

This example demonstrates how to use the `SliverStream` widget to create an efficient, on-demand loading list in Flutter.

## Features

- Infinite scrolling list with on-demand loading
- Pull-to-refresh functionality
- Error handling with visual feedback
- Interactive items with tap feedback
- Material Design 3 theming

## How it Works

1. The example creates a simulated data source using an async* generator function that yields items with a delay to mimic network requests.

2. The `SliverStream` widget is used within a `CustomScrollView` to efficiently render items as they are needed:
   - Items are loaded only when they are about to be displayed
   - Loading state is automatically handled with a progress indicator
   - Error states are handled with user feedback

3. The example includes:
   - A header section using `SliverToBoxAdapter`
   - Interactive list items with tap feedback
   - Pull-to-refresh functionality
   - Error handling with SnackBar notifications

## Running the Example

1. Make sure you have Flutter installed and set up.
2. Clone the repository.
3. Navigate to the example directory:
   ```bash
   cd example
   ```
4. Run the example:
   ```bash
   flutter run
   ```

## Code Structure

- `MyApp`: The root widget that sets up the Material app and theme
- `MyHomePage`: The main page widget that demonstrates the `SliverStream` usage
- `getItemStream()`: A simulated data source that yields items with a delay

## Key Implementation Details

```dart
SliverStream<String>(
  stream: getItemStream(),
  builder: (item) => Card(
    child: ListTile(
      title: Text(item),
      // ... other ListTile properties
    ),
  ),
  onError: (error) {
    // Error handling
  },
)
```

The `SliverStream` widget handles:
- Loading states
- Error states
- On-demand item rendering
- Memory efficiency by only keeping visible items in memory 