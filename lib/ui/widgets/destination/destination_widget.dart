// ui/widgets/destination/destination_widget.dart - CONFORME PDF
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/destination.dart';
import '../../../model/reservation.dart';
import '../../_core/app_colors.dart';
import '../bag_provider.dart';

class DestinoWidget extends StatefulWidget {
  final String nomeDestino;
  final String caminhoImagem;
  final int valord; // valor da diária
  final int valorp; // valor por pessoa
  
  const DestinoWidget({
    super.key,
    required this.nomeDestino,
    required this.caminhoImagem,
    required this.valord,
    required this.valorp,
  });

  @override
  State<DestinoWidget> createState() => _DestinoWidgetState();
}

class _DestinoWidgetState extends State<DestinoWidget> {
  int nDiarias = 0;
  int nPessoas = 0;
  int total = 0;

  // Função para incrementar número de dias
  void dias() {
    setState(() {
      nDiarias++;
    });
  }

  // Função para incrementar número de pessoas
  void nPessoasFunc() {
    setState(() {
      nPessoas++;
    });
  }

  // Função para calcular o total da viagem
  void calcTotal() {
    setState(() {
      total = (nDiarias * widget.valord) + (nPessoas * widget.valorp);
    });

    if (total > 0) {
      _showPaymentDialog();
    }
  }

  // Função para limpar os campos calculados
  void limpar() {
    setState(() {
      nDiarias = 0;
      nPessoas = 0;
      total = 0;
    });
  }

  void _showPaymentDialog() {
    String? selectedPayment;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.lightBackgroundColor,
          title: const Text('Forma de Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total: R\$ ${total.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              RadioListTile<String>(
                title: const Text('PIX (10% desconto)'),
                value: 'pix',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setDialogState(() {
                    selectedPayment = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Cartão de Crédito'),
                value: 'credito',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setDialogState(() {
                    selectedPayment = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Cartão de Débito'),
                value: 'debito',
                groupValue: selectedPayment,
                onChanged: (value) {
                  setDialogState(() {
                    selectedPayment = value;
                  });
                },
              ),
              if (selectedPayment == 'pix') ...[
                const SizedBox(height: 8),
                Text(
                  'Total com desconto: R\$ ${(total * 0.9).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: selectedPayment != null ? () => _addToCart(selectedPayment!) : null,
              child: const Text('Adicionar ao Carrinho'),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(String paymentMethod) {
    // Criar destino temporário para compatibilidade
    final destination = Destination(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: widget.nomeDestino,
      description: 'Destino incrível',
      dailyRate: widget.valord,
      personRate: widget.valorp,
      imagePath: widget.caminhoImagem,
    );

    final reservation = Reservation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      destination: destination,
      nDiarias: nDiarias,
      nPessoas: nPessoas,
      paymentMethod: paymentMethod,
      total: total.toDouble(),
      createdAt: DateTime.now(),
    );

    context.read<BagProvider>().addToBag(reservation);
    Navigator.pop(context);
    limpar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.nomeDestino} adicionado ao carrinho!'),
        backgroundColor: AppColors.mainColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 393,
      height: 350, // Ajustado de 250 para comportar todos os elementos
      decoration: BoxDecoration(
        color: AppColors.fundoCards,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do destino - Container 393x120 (proporcional)
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    AppColors.mainColor.withOpacity(0.7),
                    AppColors.mainColor,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 32,
                      color: Colors.white,
                    ),
                    Text(
                      widget.nomeDestino,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Nome do destino
            Text(
              widget.nomeDestino,
              style: const TextStyle(
                color: AppColors.mainColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // Valores da diária e por pessoa
            Text(
              'Diária: R\$ ${widget.valord} | Por pessoa: R\$ ${widget.valorp}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Row com os 4 botões conforme especificado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // B1 - Botão para número de diárias
                Column(
                  children: [
                    Text(
                      'Dias: $nDiarias',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: dias,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 40),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),
                
                // B2 - Botão para número de acompanhantes
                Column(
                  children: [
                    Text(
                      'Pessoas: $nPessoas',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: nPessoasFunc,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(40, 40),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                  ],
                ),
                
                // B3 - Botão calcular
                Column(
                  children: [
                    Text(
                      'Total: R\$ $total',
                      style: const TextStyle(color: AppColors.mainColor, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: (nDiarias > 0 || nPessoas > 0) ? calcTotal : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(70, 40),
                      ),
                      child: const Text('Calcular', style: TextStyle(color: Colors.black, fontSize: 11)),
                    ),
                  ],
                ),
                
                // B4 - Botão limpar
                Column(
                  children: [
                    const Text(
                      'Limpar',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: limpar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        minimumSize: const Size(50, 40),
                      ),
                      child: const Icon(Icons.clear, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}