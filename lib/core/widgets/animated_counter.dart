import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final double value;
  final String suffix;
  final String prefix;
  final TextStyle style;
  final bool isInteger;
  final bool isPrice;
  final int decimalPlaces;
  final Duration duration;
  final Curve curve;

  const AnimatedCounter({
    Key? key,
    required this.value,
    this.suffix = '',
    this.prefix = '',
    required this.style,
    this.isInteger = false,
    this.isPrice = false,
    this.decimalPlaces = 1,
    this.duration = const Duration(seconds: 1),
    this.curve = Curves.easeOutCubic,
  }) : super(key: key);

  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0.0;

  @override
  void initState() {
    super.initState();
    _previousValue = 0.0;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _animation = Tween<double>(begin: _previousValue, end: widget.value).animate(
        CurvedAnimation(parent: _controller, curve: widget.curve),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    if (widget.isInteger) {
      return value.toInt().toString();
    } else if (widget.isPrice) {
      return value.toStringAsFixed(2);
    } else {
      return value.toStringAsFixed(widget.decimalPlaces);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final formattedValue = _formatValue(_animation.value);
        return Text(
          '${widget.prefix}$formattedValue${widget.suffix}',
          style: widget.style,
        );
      },
    );
  }
}