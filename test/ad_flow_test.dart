import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ads/main.dart';
import 'package:app_ads/ads/rewarded_ads.dart';

class FakeAds extends RewardedAds {
  FakeAds(this.result) : super(supported: false);
  final AdResult result;
  int shows = 0;
  @override
  AdPhase get phase => AdPhase.ready;
  @override
  Future<void> prepare() async {}
  @override
  Future<AdResult> show() async {
    shows++;
    return result;
  }
}

Future<void> openIntro(WidgetTester tester, RewardedAds ads) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(MesaApp(ads: ads));
  await tester.tap(find.byTooltip('Agregar Burger de la casa'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Ver mi pedido · 1'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continuar con mi pedido →'));
  await tester.pumpAndSettle();
}

void main() {
  for (final outcome in AdResult.values) {
    testWidgets('El resultado $outcome controla la recompensa', (tester) async {
      final ads = FakeAds(outcome);
      await openIntro(tester, ads);
      expect(find.text('El postre va\npor nuestra cuenta.'), findsOneWidget);
      await tester.tap(find.text('Continuar ahora'));
      await tester.pumpAndSettle();
      expect(ads.shows, 1);
      expect(find.text('¡Ya está en cocina!'), findsOneWidget);
      expect(
        find.text('¡Recompensa obtenida!'),
        outcome == AdResult.earned ? findsOneWidget : findsNothing,
      );
      expect(
        find.text('Pedido confirmado sin recompensa'),
        outcome == AdResult.earned ? findsNothing : findsOneWidget,
      );
      await tester.tap(find.text('Volver al menú'));
      await tester.pumpAndSettle();
      expect(find.text('Agrega algo rico a tu pedido'), findsOneWidget);
    });
  }
  testWidgets('Omitir no muestra el anuncio ni otorga un postre', (
    tester,
  ) async {
    final ads = FakeAds(AdResult.earned);
    await openIntro(tester, ads);
    await tester.tap(find.text('Omitir anuncio y confirmar pedido'));
    await tester.pumpAndSettle();
    expect(ads.shows, 0);
    expect(find.text('Pedido confirmado sin recompensa'), findsOneWidget);
    expect(find.text('¡Recompensa obtenida!'), findsNothing);
  });
  testWidgets('Volver desde la introducción conserva el pedido', (
    tester,
  ) async {
    final ads = FakeAds(AdResult.earned);
    await openIntro(tester, ads);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Tu pedido'), findsOneWidget);
    expect(find.text('Burger de la casa'), findsOneWidget);
    await tester.tap(find.text('Continuar con mi pedido →'));
    await tester.pumpAndSettle();
    expect(find.text('Continuar ahora'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(ads.shows, 0);
  });
}
