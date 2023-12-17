
import 'package:all_year_heat/src/services/blockchain_service.dart';
import 'package:all_year_heat/src/view/bitcoin_miner_provider.dart';
import 'package:flutter/material.dart';

class BitcoinDataWidget extends StatefulWidget {
  const BitcoinDataWidget({super.key});

  @override
  BitcoinDataWidgetState createState() => BitcoinDataWidgetState();
}

class BitcoinDataWidgetState extends State<BitcoinDataWidget> {
  late final BlockchainService _blockchainService;
  late final MinerDataProvider _minerDataProvider;

  @override
  void initState() {
    super.initState();
    _blockchainService = BlockchainService();
    _minerDataProvider = MinerDataProvider(_blockchainService)
      ..addListener(_updateUI); // Add listener

    // Initialize or fetch any necessary data for MinerDataProvider if needed
    // For example, fetching initial data:
    Future.microtask(() async {
      await _blockchainService.fetchBitcoinData();
    });
  }

  void _updateUI() => setState(() {});

  @override
  Widget build(BuildContext context) => Expanded(
      child: ListView.builder(
        itemCount: _minerDataProvider.miners.length,
        itemBuilder: (context, index) {
          final miner = _minerDataProvider.miners[index];
          return ListTile(

            title: Text(miner.minerName),
            subtitle: Text('Profitability: ${miner.profitability}'),
            // ... other list tile properties ...
          );
        },
      ),
    );

  @override
  void dispose() {
    // Dispose any resources or listeners in MinerDataProvider if needed
    _minerDataProvider.removeListener(_updateUI); // Remove listener
    super.dispose();
  }
}
