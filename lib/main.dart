import 'package:all_year_heat/src/models/bitcoin_miner.dart';
import 'package:all_year_heat/src/screens/buy_devices.dart';
import 'package:all_year_heat/src/screens/buy_heating_service.dart';
import 'package:all_year_heat/src/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  Hive.registerAdapter(BitcoinMinerAdapter());

  final box = await Hive.openBox<BitcoinMiner>('miners');
  final miner = BitcoinMiner(
    minerName: 'Antminer S21',
    hashrate: 200,
    consumption: 3500,
    efficiency: 0.017,
  );
  await box.add(miner);

  runApp(const ProviderScope(child: AllYearHeat()));
}

class AllYearHeat extends StatefulWidget {
  const AllYearHeat({super.key});

  @override
  AllYearHeatState createState() => AllYearHeatState();
}

class AllYearHeatState extends State<AllYearHeat> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Future.microtask(() async {
      await Hive.box<BitcoinMiner>('miners').close();
    }); // Close the Hive box
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached || state == AppLifecycleState.inactive) {
      Future.microtask(() async {
        await Hive.box<BitcoinMiner>('miners').close();
      }); // Close the box when the app is detached or inactive
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.red,
            brightness: Brightness.dark, // Ensures dark mode
          ),
          // Additional customizations for neon effect
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.red.shade200), // Example text style
            bodyMedium: TextStyle(color: Colors.red.shade200), // Adjust as needed
          ),
          cardTheme: CardTheme(
            shadowColor: Colors.red.shade300, // Shadow color for neon glow
            elevation: 5, // Default elevation for cards
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.red.shade300, width: 2), // Neon border
              borderRadius: BorderRadius.circular(10), // Default border radius
            ),
          ),
          // You can also customize other components like buttons, appBar, etc.
        ),
        routes: {
          '/': (context) => const MainScreen(),
          '/buy_devices': (context) => const BuyDevices(),
          '/heating_service': (context) => const BuyHeatingService(),
        },
        debugShowCheckedModeBanner: false,
      );
}
