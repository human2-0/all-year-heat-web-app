import 'package:hive/hive.dart';
part 'bitcoin_miner.g.dart';
@HiveType(typeId: 0)
class BitcoinMiner {
  BitcoinMiner({
    required this.minerName,
    required this.hashrate,
    required this.consumption,
    required this.efficiency,
    this.profitability = 0.0,
  });

  @HiveField(0)
  String minerName;

  @HiveField(1)
  double hashrate;

  @HiveField(2)
  int consumption;

  @HiveField(3)
  double efficiency;

  @HiveField(4)
  double profitability;

  BitcoinMiner copyWith({
    String? minerName,
    double? hashrate,
    int? consumption,
    double? efficiency,
    double? profitability,
  }) => BitcoinMiner(
      minerName: minerName ?? this.minerName,
      hashrate: hashrate ?? this.hashrate,
      consumption: consumption ?? this.consumption,
      efficiency: efficiency ?? this.efficiency,
      profitability: profitability ?? this.profitability,
    );
}
