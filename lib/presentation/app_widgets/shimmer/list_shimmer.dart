import 'package:flutter/material.dart';
import 'package:ilmalogiya/presentation/app_widgets/shimmer/card_item_shimmer.dart';

class ListShimmer extends StatelessWidget {
  const ListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: 20,
      itemBuilder: (context, index) => const ArticleCardShimmer(),
    );
  }
}
