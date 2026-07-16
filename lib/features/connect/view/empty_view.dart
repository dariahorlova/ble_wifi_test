import 'package:flutter/material.dart';

import '../../../gen/assets.gen.dart';

class EmptyView extends StatelessWidget {
  final String text;
  final Widget? action;

  const EmptyView({super.key, this.text = 'Nothing is here yet!', this.action});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .center,
          children: [
            Assets.images.emptyState.image(width: 200),
            const SizedBox(height: 24),
            Text(
              text,
              textAlign: .center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (action != null) ...[const SizedBox(height: 12), action!],
          ],
        ),
      ),
    );
  }
}
