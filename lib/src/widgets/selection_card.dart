import 'package:flutter/material.dart';

class HoverableCard extends StatefulWidget {

  const HoverableCard({required this.textItems, required this.screen, super.key});
  final String screen;
  final List<String> textItems;

  @override
  HoverableCardState createState() => HoverableCardState();
}

class HoverableCardState extends State<HoverableCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
      onEnter: (_) => _setHovering(true),
      onExit: (_) => _setHovering(false),
      child: GestureDetector(
        onTap: () async {
          await Navigator.pushNamed(context, '/${widget.screen}');
        },
        child: Card(
          color: isHovering
              ? Colors.grey[200]
              : Colors.white, // Change color on hover// Dark background color for the card
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.textItems
                  .map(Text.new)
                  .toList(),
            ),
          ),
        ),
      ),
    );

  void _setHovering(bool hovering) {
    setState(() {
      isHovering = hovering;
    });
  }
}
