import 'package:flutter/material.dart';

/// The idea is to load information asynchronously and on demand,
/// so that the widget is built faster and more efficiently,
/// thus consuming less memory and processing power.
class SliverStream<T> extends StatefulWidget {
  /// Constructor
  /// [stream] - Stream to load information
  /// [builder] - Function to build the element for each item on demand
  /// [onError] - Function to handle errors
  const SliverStream({
    required this.stream,
    required this.builder,
    this.onError,
    super.key,
  });

  /// Stream to load information
  final Stream<T> stream;

  /// Function to handle errors
  final Function? onError;

  /// Function to build the element for each item on demand
  final Widget Function(T value) builder;

  @override
  State<SliverStream<T>> createState() => _SliverStreamState();
}

class _SliverStreamState<T> extends State<SliverStream<T>> {
  int? _itemCount;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    widget.stream.listen((event) {
      _updateItemCount();
    }, onError: widget.onError);
    _updateItemCount();
    // });
  }

  Future<void> _updateItemCount() async {
    try {
      final length = await widget.stream.length;
      setState(() => _itemCount = length);
    } on Exception catch (e) {
      widget.onError?.call(e);
      setState(() => _itemCount = 0);
    }
  }

  Future<T?> _getElementAt(int index) async {
    try {
      return await widget.stream.elementAt(index);
    } on Exception catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return FutureBuilder<T?>(
          future: _getElementAt(index),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsetsGeometry.all(10),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final data = snapshot.data;

            if (data == null) {
              return const SizedBox.shrink();
            }

            return widget.builder(data);
          },
        );
      }, childCount: _itemCount ?? 0),
    );
  }
}
