import 'package:flutter/material.dart';

import 'models/order.dart';
import 'ads/rewarded_ads.dart';
import 'ads/ad_intro_page.dart';

const ink = Color(0xFF29251F);
const accent = Color(0xFFB54D32);
const paper = Color(0xFFF8F5EF);
const muted = Color(0xFF82796D);

void main() => runApp(const MesaApp());

class MesaApp extends StatelessWidget {
  const MesaApp({super.key, this.ads});
  final RewardedAds? ads;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mesa · Cocina de casa',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: ColorScheme.fromSeed(seedColor: accent, surface: paper),
      appBarTheme: const AppBarTheme(
        backgroundColor: paper,
        foregroundColor: ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    ),
    home: MenuPage(ads: ads),
  );
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, this.ads});
  final RewardedAds? ads;
  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final order = RestaurantOrder();
  late final RewardedAds ads;
  @override
  void initState() {
    super.initState();
    ads = widget.ads ?? RewardedAds();
    ads.prepare();
  }

  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }

  String category = 'Todo';
  Future<void> openOrder() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => OrderPage(order: order, ads: ads),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'mesa',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            height: 1,
                          ),
                        ),
                        Text(
                          'COCINA DE CASA',
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 2.4,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5EDDF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '● Abierto',
                      style: TextStyle(
                        color: Color(0xFF496340),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(23),
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE5D8),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HECHO AL MOMENTO',
                      style: TextStyle(
                        color: accent,
                        letterSpacing: 2,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tu próxima\nmesa favorita.',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 35,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    SizedBox(height: 13),
                    Text(
                      'Buenos ingredientes. Buen provecho.',
                      style: TextStyle(fontSize: 13, color: muted),
                    ),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded, size: 15, color: accent),
                        SizedBox(width: 5),
                        Text(
                          '20–30 min',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 18),
                        Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: accent,
                        ),
                        SizedBox(width: 5),
                        Text('Para recoger', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Nuestro menú',
                      style: TextStyle(
                        fontFamily: 'serif',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                  ),
                  Text(
                    'PRECIOS EN MXN',
                    style: TextStyle(
                      letterSpacing: 1.2,
                      fontSize: 9,
                      color: muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['Todo', 'Platos', 'Bebidas']
                      .map(
                        (label) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: category == label,
                            showCheckmark: false,
                            selectedColor: ink,
                            backgroundColor: paper,
                            labelStyle: TextStyle(
                              color: category == label ? Colors.white : ink,
                              fontSize: 12,
                            ),
                            side: BorderSide(
                              color: category == label
                                  ? ink
                                  : const Color(0xFFDED7CB),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onSelected: (_) => setState(() => category = label),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              for (final dish in menu.where(
                (dish) => category == 'Todo' || dish.category == category,
              ))
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: DishCard(
                    dish: dish,
                    quantity: order.quantity(dish),
                    onAdd: () => setState(() => order.add(dish)),
                  ),
                ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'De nuestra cocina, con cariño.',
                  style: TextStyle(
                    fontFamily: 'serif',
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 14),
        child: FilledButton(
          onPressed: order.isEmpty ? null : openOrder,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  order.isEmpty
                      ? 'Agrega algo rico a tu pedido'
                      : 'Ver mi pedido · ${order.count}',
                ),
              ),
              Text(order.isEmpty ? '→' : money(order.total)),
            ],
          ),
        ),
      ),
    ),
  );
}

class DishCard extends StatelessWidget {
  const DishCard({
    super.key,
    required this.dish,
    required this.quantity,
    required this.onAdd,
  });
  final Dish dish;
  final int quantity;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFECE7DE)),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            dish.image,
            width: 94,
            height: 108,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: 94,
              height: 108,
              color: const Color(0xFFEDE5D8),
              child: Icon(dish.icon, color: accent, size: 44),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dish.tag.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    dish.tag.toUpperCase(),
                    style: const TextStyle(
                      color: accent,
                      letterSpacing: 1,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              Text(
                dish.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dish.description,
                style: const TextStyle(fontSize: 11, height: 1.4, color: muted),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    money(dish.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      color: ink,
                    ),
                  ),
                  SizedBox(
                    width: 38,
                    height: 34,
                    child: IconButton.filledTonal(
                      tooltip: 'Agregar ${dish.name}',
                      onPressed: onAdd,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFF4E8E1),
                        foregroundColor: accent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: quantity > 0
                          ? Text(
                              '$quantity',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const Icon(Icons.add, size: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.order, required this.ads});
  final RestaurantOrder order;
  final RewardedAds ads;
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _checkingOut = false;
  Future<void> checkout() async {
    if (_checkingOut || widget.order.isEmpty) return;
    setState(() => _checkingOut = true);
    final result = await Navigator.of(context).push<AdResult>(
      MaterialPageRoute(builder: (_) => AdIntroPage(ads: widget.ads)),
    );
    if (!mounted) return;
    if (result == null) {
      setState(() => _checkingOut = false);
      return;
    }
    final total = widget.order.total;
    widget.order.clear();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SuccessPage(total: total, adResult: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Tu pedido',
        style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold),
      ),
    ),
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text(
          'UN POCO DE FELICIDAD, PARA LLEVAR',
          style: TextStyle(
            letterSpacing: 1.5,
            fontSize: 10,
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        if (widget.order.isEmpty)
          const Padding(
            padding: EdgeInsets.all(28),
            child: Text(
              'Tu pedido está vacío. Vuelve al menú para agregar un platillo.',
            ),
          ),
        for (final entry in widget.order.items.entries)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      money(entry.key.price * entry.value),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Preparado al momento',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Quitar ${entry.key.name}',
                      onPressed: () =>
                          setState(() => widget.order.remove(entry.key)),
                      icon: const Icon(Icons.remove_circle_outline, size: 23),
                    ),
                    Text('${entry.value}'),
                    IconButton(
                      tooltip: 'Agregar ${entry.key.name}',
                      onPressed: () =>
                          setState(() => widget.order.add(entry.key)),
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: accent,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE5D8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Entrega'),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Recoger en restaurante',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text('Tiempo estimado')),
                  SizedBox(width: 12),
                  Flexible(
                    child: Text('20–30 minutos', textAlign: TextAlign.end),
                  ),
                ],
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    money(widget.order.total),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Precios en MXN · Pago al recoger',
                  style: TextStyle(fontSize: 11, color: muted),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Práctica escolar · No se realiza ningún cobro.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: muted),
        ),
      ],
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 16),
        child: FilledButton(
          onPressed: widget.order.isEmpty || _checkingOut ? null : checkout,
          child: const Text('Continuar con mi pedido →'),
        ),
      ),
    ),
  );
}

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key, required this.total, required this.adResult});
  final int total;
  final AdResult adResult;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE5EDDF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF496340),
                  size: 56,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                '¡Ya está en cocina!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tu pedido de demostración está confirmado.\nEstará listo para recoger en 20–30 minutos.',
                textAlign: TextAlign.center,
                style: TextStyle(height: 1.6, color: muted),
              ),
              const SizedBox(height: 24),
              Text(
                'Total: ${money(total)} MXN',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: adResult == AdResult.earned
                      ? const Color(0xFFE5EDDF)
                      : const Color(0xFFEDE5D8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      adResult == AdResult.earned
                          ? Icons.card_giftcard
                          : Icons.receipt_long_outlined,
                      color: adResult == AdResult.earned
                          ? const Color(0xFF496340)
                          : muted,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      adResult == AdResult.earned
                          ? '¡Recompensa obtenida!'
                          : 'Pedido confirmado sin recompensa',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      adResult == AdResult.earned
                          ? '1 brownie de cortesía · \$0.00\nSe agregó a tu pedido de demostración.'
                          : adResult == AdResult.unavailable
                          ? 'El anuncio no pudo mostrarse. Tu pedido sigue adelante sin postre.'
                          : 'Omitiste el anuncio. Tu pedido sigue adelante sin postre.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: muted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Volver al menú'),
              ),
              const SizedBox(height: 16),
              const Text(
                'Gracias por sentarte a nuestra mesa.',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontStyle: FontStyle.italic,
                  color: muted,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
