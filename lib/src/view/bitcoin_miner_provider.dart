import 'package:all_year_heat/src/models/bitcoin_miner.dart';
import 'package:all_year_heat/src/services/blockchain_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Import your BitcoinMiner model

class MinerDataProvider extends ChangeNotifier {

  MinerDataProvider(this.blockchainService) {
    Future.microtask(() => () async {
      await _init();
    });
  }
  final BlockchainService blockchainService;

  Box<BitcoinMiner> get _minerBox => Hive.box<BitcoinMiner>('miners');

  List<BitcoinMiner> get miners => _minerBox.values.toList();


  Future<void> _init() async {
    _minerBox.listenable().addListener(notifyListeners);
    blockchainService.addListener(_handleBlockchainUpdates);
  }

  void _handleBlockchainUpdates() {
    // This is called when BlockchainService updates its data
    // You can trigger additional logic here if needed
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    blockchainService.currency = currency;
    await blockchainService.fetchBitcoinData(); // Fetch new data with the updated currency
  }

  Future<void> addMiner(BitcoinMiner miner) async {
    await _minerBox.add(miner);
    notifyListeners();
  }

  Future<void> updateMiner(int index, BitcoinMiner miner) async {
    await _minerBox.putAt(index, miner);
    notifyListeners();
  }

  Future<void> deleteMiner(int index) async {
    await _minerBox.deleteAt(index);
    notifyListeners();
  }
}
