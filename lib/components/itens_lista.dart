import 'package:flutter/material.dart';

class ItemLista extends StatelessWidget {
  final int contador;
  const ItemLista({super.key, required this.contador});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Item ${contador.toString()}'),
            const Icon(Icons.delete, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}