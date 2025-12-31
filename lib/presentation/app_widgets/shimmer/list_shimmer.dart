import 'package:flutter/material.dart';
import 'card_item_shimmer.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const .all(16.0),
      itemCount: 20,
      itemBuilder: (context, index) => const ArticleCardShimmer(),
    );
  }
}
