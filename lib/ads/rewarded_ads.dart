import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AdPhase { loading, ready, showing, failed, unsupported }

enum AdResult { earned, skipped, unavailable }

/// Único formato publicitario de la práctica: intersticial recompensado (#7).
class RewardedAds extends ChangeNotifier {
  RewardedAds({bool? supported})
    : supported =
          supported ??
          (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.android ||
                  defaultTargetPlatform == TargetPlatform.iOS));

  static const androidUnitId = 'ca-app-pub-3940256099942544/5354046379';
  static const iosUnitId = 'ca-app-pub-3940256099942544/6978759866';
  final bool supported;
  AdPhase _phase = AdPhase.loading;
  AdPhase get phase => _phase;
  String? error;
  RewardedInterstitialAd? _ad;
  Timer? _timeout;
  bool _disposed = false, _initialized = false, _initializing = false;
  int _generation = 0;

  void _setPhase(AdPhase value) {
    if (_disposed) return;
    _phase = value;
    notifyListeners();
  }

  Future<void> prepare() async {
    if (_disposed || _initializing || _ad != null || phase == AdPhase.showing) {
      return;
    }
    if (!supported) {
      _setPhase(AdPhase.unsupported);
      return;
    }
    _setPhase(AdPhase.loading);
    if (!_initialized) {
      _initializing = true;
      try {
        await MobileAds.instance.initialize().timeout(
          const Duration(seconds: 35),
        );
        _initialized = true;
      } catch (e) {
        error = 'No se pudo inicializar AdMob: $e';
        _setPhase(AdPhase.failed);
        return;
      } finally {
        _initializing = false;
      }
    }
    if (_disposed) return;
    final generation = ++_generation;
    error = null;
    _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 30), () {
      if (generation != _generation || _disposed) return;
      _generation++;
      error = 'La carga tardó demasiado. Comprueba tu conexión.';
      _setPhase(AdPhase.failed);
    });
    try {
      await RewardedInterstitialAd.load(
        adUnitId: defaultTargetPlatform == TargetPlatform.iOS
            ? iosUnitId
            : androidUnitId,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            if (_disposed || generation != _generation) {
              ad.dispose();
              return;
            }
            _timeout?.cancel();
            _ad = ad;
            debugPrint('[ADS #7] Anuncio de prueba cargado');
            _setPhase(AdPhase.ready);
          },
          onAdFailedToLoad: (failure) {
            if (_disposed || generation != _generation) return;
            _timeout?.cancel();
            error = 'AdMob ${failure.code}: ${failure.message}';
            debugPrint('[ADS #7] $error');
            _setPhase(AdPhase.failed);
          },
        ),
      );
    } catch (e) {
      if (_disposed || generation != _generation) return;
      _timeout?.cancel();
      error = 'No se pudo solicitar el anuncio: $e';
      _setPhase(AdPhase.failed);
    }
  }

  Future<AdResult> show() async {
    final ad = _ad;
    if (ad == null || phase != AdPhase.ready) return AdResult.unavailable;
    _ad = null; // Cada objeto del SDK solo puede mostrarse una vez.
    _setPhase(AdPhase.showing);
    final completion = Completer<AdResult>();
    bool earned = false;
    void finish(AdResult result) {
      if (completion.isCompleted) return;
      ad.dispose();
      completion.complete(result);
      if (!_disposed) {
        _setPhase(AdPhase.loading);
        unawaited(prepare());
      }
    }

    ad.fullScreenContentCallback =
        FullScreenContentCallback<RewardedInterstitialAd>(
          onAdShowedFullScreenContent: (_) =>
              debugPrint('[ADS #7] Pantalla completa'),
          onAdDismissedFullScreenContent: (_) =>
              finish(earned ? AdResult.earned : AdResult.skipped),
          onAdFailedToShowFullScreenContent: (_, failure) {
            error = failure.message;
            finish(AdResult.unavailable);
          },
        );
    try {
      await ad.show(
        onUserEarnedReward: (_, reward) {
          // Nunca se otorga recompensa por cerrar el anuncio ni por un temporizador.
          earned = true;
          debugPrint(
            '[ADS #7] onUserEarnedReward: ${reward.amount} ${reward.type}',
          );
        },
      );
    } catch (_) {
      finish(AdResult.unavailable);
    }
    return completion.future;
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    _timeout?.cancel();
    _ad?.dispose();
    super.dispose();
  }
}
