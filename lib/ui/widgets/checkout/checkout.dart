// ui/widgets/checkout/checkout.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../_core/app_colors.dart';
import '../bag_provider.dart';
import '../auth/auth_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Consumer2<BagProvider, AuthProvider>(
        builder: (context, bagProvider, authProvider, _) {
          if (bagProvider.reservationsOnBag.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Carrinho vazio',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Informações do usuário
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dados do Cliente',
                      style: TextStyle(
                        color: AppColors.mainColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Nome: ${authProvider.currentUser?.name ?? ''}'),
                    Text('Email: ${authProvider.currentUser?.email ?? ''}'),
                    Text('Telefone: ${authProvider.currentUser?.phone ?? ''}'),
                    Text('Endereço: ${authProvider.currentUser?.address ?? ''}'),
                  ],
                ),
              ),
              
              // Lista de reservas
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bagProvider.reservationsOnBag.length,
                  itemBuilder: (context, index) {
                    final reservation = bagProvider.reservationsOnBag[index];
                    return Card(
                      color: AppColors.fundoCards,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    reservation.destination.name,
                                    style: const TextStyle(
                                      color: AppColors.mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    bagProvider.removeReservation(reservation);
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                            Text('Dias: ${reservation.nDiarias}'),
                            Text('Pessoas: ${reservation.nPessoas}'),
                            Text('Pagamento: ${reservation.paymentMethod.toUpperCase()}'),
                            Text(
                              'Total: R\$ ${reservation.total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            if (reservation.paymentMethod.toLowerCase() == 'pix') ...[
                              Text(
                                'Com desconto PIX: R\$ ${reservation.totalWithDiscount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Total e finalizar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.lightBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Geral:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${bagProvider.totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: AppColors.mainColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              bagProvider.clearBag();
                              Navigator.pop(context);
                            },
                            child: const Text('Limpar Carrinho'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _showConfirmationDialog(context, bagProvider);
                            },
                            child: const Text('Finalizar Compra'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, BagProvider bagProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackgroundColor,
        title: const Text('Confirmar Compra'),
        content: Text(
          'Deseja confirmar a compra de ${bagProvider.reservationsOnBag.length} reserva(s) no valor total de R\$ ${bagProvider.totalPrice.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              bagProvider.clearBag();
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Compra realizada com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}