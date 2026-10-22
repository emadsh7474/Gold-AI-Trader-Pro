import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const GoldAITrader());
}

class GoldAITrader extends StatelessWidget {
  const GoldAITrader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gold AI Trader Pro',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101014),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: TradingDashboard(),
      ),
    );
  }
}

class TradingDashboard extends StatefulWidget {
  const TradingDashboard({super.key});

  @override
  State<TradingDashboard> createState() =>
      _TradingDashboardState();
}

class _TradingDashboardState extends State<TradingDashboard> {
  final Random random = Random();

  Timer? timer;

  double balance = 1000;
  double goldPrice = 2700;
  double previousPrice = 2700;
  double totalProfit = 0;

  bool botActive = false;

  String timeframe = 'M15';
  String signal = 'در انتظار تحلیل';
  String marketStatus = 'آماده';

  int analysisCount = 0;

  final List<String> logs = [];

  void startBot() {
    if (botActive) return;

    setState(() {
      botActive = true;
      marketStatus = 'در حال تحلیل آزمایشی';
    });

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => analyzeMarket(),
    );
  }

  void stopBot() {
    timer?.cancel();

    setState(() {
      botActive = false;
      marketStatus = 'متوقف';
      signal = 'بدون سیگنال';
    });
  }

  void analyzeMarket() {
    previousPrice = goldPrice;

    final change = (random.nextDouble() - 0.5) * 8;

    goldPrice += change;

    final volatility = change.abs();

    if (volatility > 3) {
      timeframe = 'M5';
    } else if (volatility > 1.5) {
      timeframe = 'M15';
    } else {
      timeframe = 'H1';
    }

    if (change > 2) {
      signal = 'احتمال خرید';
    } else if (change < -2) {
      signal = 'احتمال فروش';
    } else {
      signal = 'صبر';
    }

    analysisCount++;

    logs.insert(
      0,
      'تحلیل $analysisCount | $timeframe | $signal',
    );

    if (logs.length > 15) {
      logs.removeLast();
    }

    setState(() {});
  }

  Widget infoCard(String title, String value, IconData icon) {
    return Card(
      color: const Color(0xFF202026),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          '🥇 Gold AI Trader Pro',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Text(
              'ربات تحلیلگر آزمایشی طلا',
              style: TextStyle(
                fontSize: 22,
                color: Colors.amber,
              ),
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'حالت دمو: قیمت‌ها ساختگی هستند و معامله واقعی انجام نمی‌شود.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.orange),
          ),

          const SizedBox(height: 20),

          infoCard(
            'سرمایه آزمایشی',
            '\$${balance.toStringAsFixed(2)}',
            Icons.account_balance_wallet,
          ),

          infoCard(
            'قیمت شبیه‌سازی‌شده طلا',
            '\$${goldPrice.toStringAsFixed(2)}',
            Icons.show_chart,
          ),

          infoCard(
            'تایم‌فریم انتخاب‌شده',
            timeframe,
            Icons.access_time,
          ),

          infoCard(
            'سیگنال آزمایشی',
            signal,
            Icons.psychology,
          ),

          infoCard(
            'وضعیت ربات',
            marketStatus,
            Icons.smart_toy,
          ),

          infoCard(
            'تعداد تحلیل‌ها',
            '$analysisCount',
            Icons.analytics,
          ),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: botActive ? null : startBot,
            icon: const Icon(Icons.play_arrow),
            label: const Text('شروع تحلیل آزمایشی'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: botActive ? stopBot : null,
            icon: const Icon(Icons.stop),
            label: const Text('توقف ربات'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'گزارش تحلیل‌ها',
            style: TextStyle(
              fontSize: 20,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...logs.map(
            (log) => Card(
              color: const Color(0xFF202026),
              child: ListTile(
                leading: const Icon(
                  Icons.analytics,
                  color: Colors.amber,
                ),
                title: Text(log),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
