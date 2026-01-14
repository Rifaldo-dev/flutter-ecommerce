import 'package:flutter/material.dart';
import 'animation_types.dart';

/// Animated Icon Button with various effects
class AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double? backgroundSize;
  final String? tooltip;
  final AnimationType animationType;
  final Duration animationDuration;

  const AnimatedIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size = 24.0,
    this.backgroundSize,
    this.tooltip,
    this.animationType = AnimationType.scale,
    this.animationDuration = const Duration(milliseconds: 150),
  }) : super(key: key);

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed == null) return;

    setState(() => _isPressed = true);
    _animationController.forward();

    if (widget.animationType == AnimationType.pulse) {
      _pulseController.forward().then((_) {
        _pulseController.reverse();
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
    final iconColor = widget.color ?? theme.iconTheme.color ?? Colors.black;
    final backgroundSize = widget.backgroundSize ?? widget.size + 16;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onPressed,
      child: Tooltip(
        message: widget.tooltip ?? '',
        child: AnimatedBuilder(
          animation: Listenable.merge([_animationController, _pulseController]),
          builder: (context, child) {
            double scale = 1.0;
            double rotation = 0.0;

            switch (widget.animationType) {
              case AnimationType.scale:
                scale = _scaleAnimation.value;
                break;
              case AnimationType.rotation:
                rotation = _rotationAnimation.value;
                break;
              case AnimationType.pulse:
                scale = _pulseAnimation.value;
                break;
              case AnimationType.bounce:
                scale = _isPressed ? 0.9 : 1.0;
                break;
              case AnimationType.fade:
                // Fade animation not applicable for icon buttons, use scale instead
                scale = _scaleAnimation.value;
                break;
              case AnimationType.ripple:
                // Ripple animation not applicable for icon buttons, use pulse instead
                scale = _pulseAnimation.value;
                break;
            }

            return Transform.scale(
              scale: scale,
              child: Transform.rotate(
                angle: rotation,
                child: Container(
                  width: backgroundSize,
                  height: backgroundSize,
                  decoration: widget.backgroundColor != null
                      ? BoxDecoration(
                          color: widget.backgroundColor,
                          shape: BoxShape.circle,
                          boxShadow: _isPressed
                              ? []
                              : [
                                  BoxShadow(
                                    color: widget.backgroundColor!
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        )
                      : null,
                  child: Center(
                    child: Icon(
                      widget.icon,
                      size: widget.size,
                      color: widget.onPressed != null
                          ? iconColor
                          : iconColor.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Specialized animated icon buttons for common use cases
class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;
  final Color? favoriteColor;
  final Color? unfavoriteColor;
  final double size;

  const AnimatedFavoriteButton({
    Key? key,
    required this.isFavorite,
    this.onPressed,
    this.favoriteColor,
    this.unfavoriteColor,
    this.size = 24.0,
  }) : super(key: key);

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
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
    final favoriteColor = widget.favoriteColor ?? Colors.red;
    final unfavoriteColor = widget.unfavoriteColor ?? Colors.grey;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedIconButton(
            icon: widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            onPressed: _handleTap,
            color: widget.isFavorite ? favoriteColor : unfavoriteColor,
            size: widget.size,
            animationType: AnimationType.pulse,
          ),
        );
      },
    );
  }
}

/// Animated Cart Button with badge
class AnimatedCartButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final int itemCount;
  final Color? color;
  final Color? badgeColor;
  final double size;

  const AnimatedCartButton({
    Key? key,
    this.onPressed,
    this.itemCount = 0,
    this.color,
    this.badgeColor,
    this.size = 24.0,
  }) : super(key: key);

  @override
  State<AnimatedCartButton> createState() => _AnimatedCartButtonState();
}

class _AnimatedCartButtonState extends State<AnimatedCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedCartButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.itemCount > oldWidget.itemCount) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = widget.badgeColor ?? theme.primaryColor;

    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedIconButton(
                icon: Icons.shopping_cart_outlined,
                onPressed: widget.onPressed,
                color: widget.color,
                size: widget.size,
                animationType: AnimationType.scale,
              ),
              if (widget.itemCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      widget.itemCount > 99
                          ? '99+'
                          : widget.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
