import 'dart:async';

import 'package:flutter/material.dart';

import '../main.dart' show accent, ink, muted;
import 'rewarded_ads.dart';

class AdIntroPage extends StatefulWidget {
  const AdIntroPage({super.key, required this.ads});
  final RewardedAds ads;
  @override
  State<AdIntroPage> createState() => _AdIntroPageState();
}

class _AdIntroPageState extends State<AdIntroPage> {
  Timer? _timer;
  int _seconds = 8;
  bool _showing = false;

  @override
  void initState() {
    super.initState();
    widget.ads.addListener(_changed);
    _startCountdown();
  }

  void _startCountdown() {
    if (_timer != null || widget.ads.phase != AdPhase.ready || _showing) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        unawaited(_show());
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _changed() {
    if (!mounted) return;
    _startCountdown();
    setState(() {});
  }

  Future<void> _show() async {
    if (_showing || widget.ads.phase != AdPhase.ready) return;
    _timer?.cancel();
    setState(() => _showing = true);
    final result = await widget.ads.show();
    if (mounted) Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.ads.removeListener(_changed);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = widget.ads.phase == AdPhase.ready;
    final failed = widget.ads.phase == AdPhase.failed;
    final unsupported = widget.ads.phase == AdPhase.unsupported;
    return PopScope(
      canPop: !_showing,
      child: Scaffold(
        appBar: AppBar(title: const Text('Un detalle de la casa')),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  const Text(
                    'ANTES DE CONFIRMAR',
                    style: TextStyle(
                      color: accent,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1E2D5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cake_outlined,
                      size: 70,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'El postre va\npor nuestra cuenta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 34,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Completa el anuncio y recibe 1 brownie de cortesía en este pedido de demostración.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.6, color: muted),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Puedes omitirlo y confirmar tu pedido sin postre. No necesitas hacer clic ni instalar nada.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, height: 1.6, color: muted),
                  ),
                  const SizedBox(height: 28),
                  if (_showing)
                    const Text('Anuncio en curso…')
                  else if (ready)
                    Text(
                      'El anuncio comenzará en $_seconds s',
                      style: const TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else if (unsupported)
                    const Text(
                      'Los anuncios de AdMob están disponibles en Android e iOS.',
                      textAlign: TextAlign.center,
                    )
                  else if (failed)
                    const Text(
                      'El anuncio no está disponible. Puedes reintentar o continuar sin él.',
                      textAlign: TextAlign.center,
                    )
                  else
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Preparando anuncio de prueba…'),
                      ],
                    ),
                  const SizedBox(height: 22),
                  if (ready && !_showing)
                    FilledButton(
                      onPressed: _show,
                      child: const Text('Continuar ahora'),
                    ),
                  if (failed && !_showing)
                    FilledButton(
                      onPressed: widget.ads.prepare,
                      child: const Text('Reintentar carga'),
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _showing
                        ? null
                        : () => Navigator.of(context).pop(AdResult.skipped),
                    child: const Text('Omitir anuncio y confirmar pedido'),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'ANUNCIO DE PRUEBA · FORMATO 7',
                    style: TextStyle(
                      color: muted,
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
