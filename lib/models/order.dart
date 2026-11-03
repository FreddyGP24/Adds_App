import 'package:flutter/material.dart';

class Dish {
  const Dish(this.name, this.description, this.price, this.category, this.image, this.icon, {this.tag = ''});
  final String name, description, category, image, tag;
  final int price;
  final IconData icon;
}

const menu = [
  Dish('Burger de la casa', 'Res a la parrilla, cheddar\ny nuestro aderezo especial.', 145, 'Platos', 'assets/images/burger.jpg', Icons.lunch_dining, tag: 'La favorita'),
  Dish('Pizza margarita', 'Tomate, mozzarella fresca\ny hojas de albahaca.', 169, 'Platos', 'assets/images/pizza.jpg', Icons.local_pizza, tag: 'Recién horneada'),
  Dish('Ensalada del huerto', 'Vegetales frescos, aguacate\ny vinagreta de la casa.', 115, 'Platos', 'assets/images/salad.jpg', Icons.eco_outlined),
  Dish('Limonada fresca', 'Limón natural, agua mineral\ny un toque de hierbabuena.', 45, 'Bebidas', 'assets/images/lemonade.jpg', Icons.local_drink_outlined),
];

String money(int pesos) => '\$$pesos.00';

class RestaurantOrder {
  final Map<Dish, int> _items = {};
  Map<Dish, int> get items => Map.unmodifiable(_items);
  int quantity(Dish dish) => _items[dish] ?? 0;
  bool get isEmpty => _items.isEmpty;
  int get count => _items.values.fold(0, (sum, quantity) => sum + quantity);
  int get total => _items.entries.fold(0, (sum, entry) => sum + entry.key.price * entry.value);
  void add(Dish dish) => _items.update(dish, (value) => value + 1, ifAbsent: () => 1);
  void remove(Dish dish) {
    if (quantity(dish) <= 1) {
      _items.remove(dish);
    } else {
      _items[dish] = quantity(dish) - 1;
    }
  }
  void clear() => _items.clear();
}
