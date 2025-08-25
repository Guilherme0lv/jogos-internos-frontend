import 'package:flutter/material.dart';

class DefaultDialogContainer extends StatelessWidget {
  final Widget child;
  const DefaultDialogContainer({
      super.key,
      required this.child,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(8),
              ),
              child: child,  
            );
  }
}