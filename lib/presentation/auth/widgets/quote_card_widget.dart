import "package:flutter/material.dart";
import "../../../utils/ui/app_colors.dart";

class QuoteCardWidget extends StatelessWidget {
  const QuoteCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E7D5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5D5C0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFE4D3BD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "«Bitsun Ilmsizlik!»",
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF614E3F),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
