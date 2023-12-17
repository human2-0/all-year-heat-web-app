

class BitcoinData {
  // Map to store last prices for various currencies

  BitcoinData({required this.hashRate, required this.difficulty, required this.lastPrices, required this.blockReward});
  double hashRate;
  double difficulty;
  Map<String, double> lastPrices;
  double blockReward;
}
