import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TotalIncomeWidget extends StatefulWidget {
  final num totalIncome;

  const TotalIncomeWidget({super.key, required this.totalIncome});

  @override
  _TotalIncomeWidgetState createState() => _TotalIncomeWidgetState();
}

class _TotalIncomeWidgetState extends State<TotalIncomeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimationStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: widget.totalIncome.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.sp,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/bg2.jpg"),
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_isAnimationStarted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _controller.forward();
                _isAnimationStarted = true;
              });
            }
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\$${_animation.value.toFormattedString()}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "T O T A L  I N C O M E",
                      style: TextStyle(
                        color: Colors.grey.shade300,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

extension NumExtension on num {
  String toFormattedString() {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(this);
  }
}
