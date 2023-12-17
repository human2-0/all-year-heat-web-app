import 'package:all_year_heat/src/widgets/bitcoin_profits.dart';
import 'package:all_year_heat/src/widgets/selection_card.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.info))],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('How you can save?', style: TextStyle( fontSize: 30,shadows: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.red.shade300,
                  spreadRadius: 5,
                ),
              ],)),
            )),
        const Gap(20),
        const BitcoinDataWidget(),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HoverableCard(screen: 'buy_devices',textItems: ['buy devices', "what's included", '*feature1', '*feature1']),
            Gap(2),
            HoverableCard(screen: 'heating_service',textItems: ['investment risk free', "what's included", '*feature1', '*feature1']),
          ],
        ),
      ]));
}
