import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:satsails/models/balance_model.dart';
import 'package:satsails/providers/settings_provider.dart';
import 'bitcoin_provider.dart';

final openHiveBoxProvider = FutureProvider.autoDispose<int>((ref) async {
  final box = await Hive.openBox('bitcoin');
  return box.get('balance', defaultValue: 0);
});

final initializeBalanceProvider = FutureProvider.autoDispose<Balance>((ref) async {
  final balance = await ref.watch(openHiveBoxProvider.future);
  // final balance = await ref.watch(initBitcoinBalanceProvider.future);

  return Balance(
    btcBalance: balance,
    liquidBalance: 0,
    usdBalance: 0,
    cadBalance: 0,
    eurBalance: 0,
    brlBalance: 0,
  );
});

final balanceNotifierProvider = StateNotifierProvider.autoDispose<BalanceModel, Balance>((ref) {
  final initialBalance = ref.watch(initializeBalanceProvider);

  return BalanceModel(initialBalance.when(
    data: (balance) => balance,
    loading: () => Balance(
      btcBalance: 0,
      liquidBalance: 0,
      usdBalance: 0,
      cadBalance: 0,
      eurBalance: 0,
      brlBalance: 0,
    ),
    error: (Object error, StackTrace stackTrace) {
      throw error;
    },
  ));
});

final totalBalanceInCurrencyProvider = FutureProvider.family.autoDispose<double, String>((ref, currency) async {
  final balanceModel = ref.watch(balanceNotifierProvider.notifier);
  return await balanceModel.totalBalanceInCurrency(currency);
});

final totalBalanceInDenominationProvider = FutureProvider.family.autoDispose<double, String>((ref, denomination) async {
  final balanceModel = ref.watch(balanceNotifierProvider.notifier);
  return balanceModel.totalBalanceInDenomination(denomination);
});

final currentBitcoinPriceInCurrencyProvider = FutureProvider.family.autoDispose<double, String>((ref, currency) async {
  final balanceModel = ref.watch(balanceNotifierProvider.notifier);
  return await balanceModel.currentBitcoinPriceInCurrency(currency);
});

final percentageChangeProvider = FutureProvider.autoDispose<Percentage>((ref) async {
  final balanceModel = ref.watch(balanceNotifierProvider.notifier);
  return await balanceModel.percentageOfEachCurrency();
});

final initBitcoinBalanceProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(bitcoinProvider.future).then((bitcoin) async {
    await ref.watch(syncBitcoinProvider.future);
    final balance = await ref.watch(getBalanceProvider.future);
    final box = await Hive.openBox('bitcoin');
    if (balance.total == 0 || !ref.watch(onlineProvider)) {
      return box.get('balance', defaultValue: 0) as int;
    } else {
      await box.put('balance', balance.total.toInt());
      return balance.total.toInt();
    }
  });
});