import 'package:flutter/material.dart';
import 'animation_types.dart';

/// Custom animated button with various animation effects
class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Widget? icon;
  final bool isLoading;
  final AnimationType animationType;
  final Duration animationDuration;

  const AnimatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
    this.isLoading = false,
    this.animationType = AnimationType.scale,
    this.animationDuration = const Duration(milliseconds: 150),
  }) : super(key: key);

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late AnimationController _rippleController;
  late Animation<double> _rippleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();

    if (widget.animationType == AnimationType.ripple) {
      _rippleController.forward().then((_) {
        _rippleController.reset();
      });
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = widget.backgroundColor ?? theme.primaryColor;
    final textColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.animationType == AnimationType.scale
                ? _scaleAnimation.value
                : 1.0,
            child: Opacity(
              opacity: widget.animationType == AnimationType.fade
                  ? _opacityAnimation.value
                  : 1.0,
              child: Container(
                width: widget.width,
                height: widget.height ?? 50,
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.onPressed != null
                      ? backgroundColor
                      : backgroundColor.withOpacity(0.5),
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                  boxShadow: _isPressed
                      ? []
                      : [
                          BoxShadow(
                            color: backgroundColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ripple effect
                    if (widget.animationType == AnimationType.ripple)
                      AnimatedBuilder(
                        animation: _rippleAnimation,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: widget.borderRadius ??
                                  BorderRadius.circular(8),
                              color: Colors.white.withOpacity(
                                0.3 * (1 - _rippleAnimation.value),
                              ),
                            ),
                            transform: Matrix4.identity()
                              ..scale(_rippleAnimation.value),
                          );
                        },
                      ),

                    // Button content
                    if (widget.isLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.icon != null) ...[
                            widget.icon!,
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Specialized animated buttons for common use cases
class AnimatedElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;

  const AnimatedElevatedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      textColor: textColor,
      width: width,
      animationType: AnimationType.scale,
    );
  }
}

class AnimatedOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double? width;

  const AnimatedOutlinedButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = this.borderColor ?? theme.primaryColor;
    final textColor = this.textColor ?? theme.primaryColor;

    return AnimatedButton(
      text: text,
      onPressed: onPressed,
      icon: icon,
      isLoading: isLoading,
      backgroundColor: Colors.transparent,
      textColor: textColor,
      width: width,
      animationType: AnimationType.ripple,
      borderRadius: BorderRadius.circular(8),
    );
  }
}

/// Floating Action Button with animation
class AnimatedFAB extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final String? tooltip;

  const AnimatedFAB({
    Key? key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
    this.tooltip,
  }) : super(key: key);

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: FloatingActionButton(
              onPressed: _handleTap,
              backgroundColor: widget.backgroundColor,
              tooltip: widget.tooltip,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
