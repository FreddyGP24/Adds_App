import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_ads/main.dart';
import 'package:app_ads/models/order.dart';
import 'package:app_ads/ads/rewarded_ads.dart';

void main() {
  test('Calcula cantidades y elimina productos sin valores negativos', () {
    final order = RestaurantOrder();
    order.add(menu.first);
    order.add(menu.first);
    order.add(menu.last);
    expect(order.count, 3);
    expect(order.total, 335);
    order.remove(menu.first);
    expect(order.total, 190);
    order.remove(menu.last);
    order.remove(menu.last);
    expect(order.quantity(menu.last), 0);
    order.clear();
    expect(order.isEmpty, isTrue);
  });
  testWidgets('Agrega un platillo y permite revisar el pedido', (tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MesaApp(ads: RewardedAds(supported: false)));
    expect(find.text('Nuestro menú'), findsOneWidget);
    await tester.tap(find.byTooltip('Agregar Burger de la casa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver mi pedido · 1'));
    await tester.pumpAndSettle();
    expect(find.text('Tu pedido'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
  });
}
