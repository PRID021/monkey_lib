import 'package:flutter/material.dart';

class TwoTextToggleButton extends StatelessWidget {
  final String fistContext;
  final String secondContext;
  final bool isFirstSelected;
  final Function(bool value)? onToggle;

  const TwoTextToggleButton({
    Key? key,
    required this.fistContext,
    required this.secondContext,
    required this.isFirstSelected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 136,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xFF767680).withOpacity(0.12),
      ),
      padding: EdgeInsets.all(2),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          AnimatedAlign(
            alignment:
                isFirstSelected ? Alignment.centerLeft : Alignment.centerRight,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeIn,
            child: Container(
              width: 67,
              height: 28,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Text(
                  fistContext,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // setState(() {
                  //   isFirstSelected = true;
                  // });
                  onToggle?.call(true);
                },
              ),
              GestureDetector(
                child: Text(
                  secondContext,
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  // setState(() {
                  //   isFirstSelected = false;
                  // });
                  onToggle?.call(false);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
