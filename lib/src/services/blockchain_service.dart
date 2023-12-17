import 'dart:async';
import 'dart:convert';

import 'package:all_year_heat/src/models/bitcoin_data.dart';
import 'package:all_year_heat/src/models/bitcoin_miner.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class BlockchainService extends ChangeNotifier {
  BlockchainService({String currency = 'GBP'}) : _currency = currency {
    _timer = Timer.periodic(const Duration(minutes: 10), (t) async {
      await fetchBitcoinData();
    });
  }
  String _currency;
  BitcoinData? _bitcoinData;
  Timer? _timer;

  BitcoinData? get bitcoinData => _bitcoinData;

  String get currency => _currency;


  set currency(String newCurrency) {
    if (_currency != newCurrency) {
      _currency = newCurrency;
      // Optionally, trigger an update when currency changes
      // fetchBitcoinData();
      notifyListeners();
    }
  }


  Future<void> fetchBitcoinData() async {
    try {
      final difficultyResponse = await http.get(Uri.parse('https://blockchain.info/q/getdifficulty'));
      final hashrateResponse = await http.get(Uri.parse('https://blockchain.info/q/hashrate'));
      final blockRewardResponse = await http.get(Uri.parse('https://blockchain.info/q/bcperblock'));

      if (difficultyResponse.statusCode == 200 &&
          hashrateResponse.statusCode == 200 &&
          blockRewardResponse.statusCode == 200) {
        final difficulty = double.parse(difficultyResponse.body);
        //deal with hexa decimals
        final hashrate = double.parse(hashrateResponse.body);
        final blockReward = double.parse(blockRewardResponse.body);
        await fetchLastPrices().then((lastPrices) async {
          _bitcoinData =
              BitcoinData(hashRate: hashrate, difficulty: difficulty, lastPrices: lastPrices, blockReward: blockReward);
          await updateMinersProfitability(_currency);
          notifyListeners();
          return _bitcoinData;
        });

      } else {
        throw Exception('Failed to load data');
      }
    } on FormatException catch (e) {
      debugPrint('Error: $e');
      throw Exception('Failed to fetch data');
    }
  }

  void cancelFetchingData() {
    _timer?.cancel();
  }

  Future<Map<String, double>> fetchLastPrices() async {
    final response = await http.get(Uri.parse('https://blockchain.info/ticker'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final lastPrices = <String, double>{};
      data.forEach((key, value) {
        final currencyData = value as Map<String, dynamic>;
        lastPrices[key] = currencyData['last'] as double;
      });
      return lastPrices;
    } else {
      throw Exception('Failed to load last prices');
    }
  }
  double calculateDailyIncome(BitcoinMiner miner, String currency,) {
    if (_bitcoinData == null) {
      return 0;
    }

    final priceOfBitcoin = _bitcoinData!.lastPrices[currency] ?? 0.0;
    debugPrint('price of BTC in GBP$priceOfBitcoin');
    const blocksPerDay = (24 * 60) / 10; // Approx. number of blocks mined in a day (10 minutes per block)
    final totalBlockRewardPerDay = blocksPerDay * _bitcoinData!.blockReward;

    // Calculate the miner's share of the total network hashrate
    final minerShare = miner.hashrate / _bitcoinData!.hashRate;

    // Calculate the miner's expected share of the total daily block rewards
    final minerRewardPerDay = minerShare * totalBlockRewardPerDay;


    // Convert the reward to Bitcoin (from satoshis) and then to the selected currency
    // Convert the reward to the selected currency without converting to Bitcoin first
    var revenueInSelectedCurrency = minerRewardPerDay * priceOfBitcoin;

    debugPrint('$revenueInSelectedCurrency');

    // Round to two decimal places



    // Calculate daily electricity cost
    // final dailyElectricityCost = (miner.consumption / 1000.0) * electricityCostPerKWh * 24;
    //
    // // Final daily income
    // final dailyIncome = revenue - dailyElectricityCost;

    return revenueInSelectedCurrency = double.parse(revenueInSelectedCurrency.toStringAsFixed(2));
  }

  Future<void> updateMinersProfitability(String currency) async {
    if (_bitcoinData == null) {
      debugPrint('Blockchain data is null');
      return;
    }

    // Debugging: Check if currency is valid and price is not zero
    if (!_bitcoinData!.lastPrices.containsKey(currency) || _bitcoinData!.lastPrices[currency] == 0) {
      debugPrint('Invalid currency or Bitcoin price is zero for $currency');
      return;
    }

    final minerBox = Hive.box<BitcoinMiner>('miners');
    for (var i = 0; i < minerBox.length; i++) {
      final miner = minerBox.getAt(i);
      if (miner != null) {
        final dailyIncome = calculateDailyIncome(miner, currency);
        // Debugging: Log calculated daily income
        debugPrint('Calculated daily income for miner ${miner.minerName}: $dailyIncome');

        final updatedMiner = miner.copyWith(profitability: dailyIncome);
        debugPrint('Updating miner ${miner.minerName} with profitability: ${updatedMiner.profitability}');
        await minerBox.putAt(i, updatedMiner);
      }
    }
  }
}
