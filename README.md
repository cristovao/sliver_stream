# SliverStream

A Flutter widget that efficiently renders stream data in a scrollable list using slivers. This widget is designed to handle dynamic data loading with minimal memory footprint by loading items on demand.

## Features

- 🔄 On-demand loading of stream items
- 📱 Efficient memory usage through sliver-based rendering
- ⚡ Automatic loading state handling
- ❌ Built-in error handling
- 🎨 Customizable item builder
- 🔄 Broadcast stream support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  sliver_stream: ^1.0.0
```

## Usage

### Basic Usage

```dart
SliverStream<String>(
  stream: yourStream,
  builder: (item) => ListTile(
    title: Text(item),
  ),
  onError: (context, error, stacktrace) {
    print('Error: $error');
  },
)
```

### Within CustomScrollView

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      title: Text('My List'),
    ),
    SliverStream<String>(
      stream: yourStream,
      builder: (item) => Card(
        child: ListTile(
          title: Text(item),
        ),
      ),
    ),
  ],
)
```

### With Error Handling

```dart
SliverStream<String>(
  stream: yourStream,
  builder: (item) => ListTile(
    title: Text(item),
  ),
  onError: (context, error, stacktrace) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  },
)
```

### Custom Loading Widget

```dart
SliverStream<String>(
  stream: yourStream,
  builder: (item) => ListTile(
    title: Text(item),
  ),
  loadingWidget: const Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ),
  ),
)
```

The `loadingWidget` parameter allows you to customize the loading state appearance. If not provided, a default loading indicator will be shown. You can use any widget as your loading indicator, such as:

- Custom animations
- Shimmer effects
- Branded loading screens
- Skeleton loaders
- Progress indicators with custom styling

## How It Works

The `SliverStream` widget:
1. Takes a stream of data as input
2. Loads items on demand as they are scrolled into view
3. Efficiently manages memory by only keeping visible items
4. Handles loading and error states automatically

### Key Components

- `stream`: The source of data (must be a broadcast stream)
- `builder`: Function to build widget for each item
- `onError`: Optional error handler

## Important Notes

1. The stream must be a broadcast stream if it needs to be listened to multiple times
2. Items are loaded on demand, not all at once
3. The widget automatically handles loading states
4. Error handling is optional but recommended

## Example

A complete example showing how to use `SliverStream` with a simulated data source:

```dart
Stream<String> getItemStream() async* {
  for (int i = 1; i <= 100; i++) {
    await Future.delayed(Duration(milliseconds: 500));
    yield 'Item $i';
  }
}

// In your widget:
SliverStream<String>(
  stream: getItemStream(),
  builder: (item) => Card(
    child: ListTile(
      title: Text(item),
    ),
  ),
)
```

## Performance Considerations

- Items are loaded only when needed
- Memory usage is optimized for large lists
- Smooth scrolling performance
- Efficient resource management

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
