// ui/widgets/home/home_screen.dart - CONFORME PDF (Stateless)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../_core/app_colors.dart';
import '../destination/destination_widget.dart';
import '../auth/auth_provider.dart';
import '../auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista com os 10 destinos conforme especificado no PDF
    final List<Map<String, dynamic>> destinations = [
      {
        'nome': 'Angra dos Reis',
        'imagem': 'assets/destinations/angra.jpg',
        'valord': 384,
        'valorp': 70,
      },
      {
        'nome': 'Jericoacoara',
        'imagem': 'assets/destinations/jericoacoara.jpg',
        'valord': 571,
        'valorp': 75,
      },
      {
        'nome': 'Arraial do Cabo',
        'imagem': 'assets/destinations/arraial.jpg',
        'valord': 534,
        'valorp': 65,
      },
      {
        'nome': 'Florianópolis',
        'imagem': 'assets/destinations/floripa.jpg',
        'valord': 348,
        'valorp': 85,
      },
      {
        'nome': 'Madri',
        'imagem': 'assets/destinations/madrid.jpg',
        'valord': 401,
        'valorp': 85,
      },
      {
        'nome': 'Paris',
        'imagem': 'assets/destinations/paris.jpg',
        'valord': 546,
        'valorp': 95,
      },
      {
        'nome': 'Orlando',
        'imagem': 'assets/destinations/orlando.jpg',
        'valord': 616,
        'valorp': 105,
      },
      {
        'nome': 'Las Vegas',
        'imagem': 'assets/destinations/vegas.jpg',
        'valord': 504,
        'valorp': 110,
      },
      {
        'nome': 'Roma',
        'imagem': 'assets/destinations/roma.jpg',
        'valord': 478,
        'valorp': 85,
      },
      {
        'nome': 'Chile',
        'imagem': 'assets/destinations/chile.jpg',
        'valord': 446,
        'valorp': 95,
      },
    ];

    return Scaffold(
      // AppBar com título do aplicativo conforme PDF
      appBar: AppBar(
        title: const Text('S&M Hotel'),
        backgroundColor: AppColors.backgroundColor,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              switch (value) {
                case 'users':
                  _showUsersDialog(context);
                  break;
                case 'reset':
                  _showResetDialog(context);
                  break;
                case 'logout':
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'users',
                child: ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Ver Usuários'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'reset',
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Resetar Banco'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      
      // Body com ListView conforme especificado no PDF
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: destinations.length,
        itemBuilder: (context, index) {
          final destination = destinations[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DestinoWidget(
              nomeDestino: destination['nome'],
              caminhoImagem: destination['imagem'],
              valord: destination['valord'],
              valorp: destination['valorp'],
            ),
          );
        },
      ),
    );
  }

  void _showUsersDialog(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final users = await authProvider.getAllUsers();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackgroundColor,
        title: const Text('Usuários Cadastrados'),
        content: SizedBox(
          width: double.maxFinite,
          child: users.isEmpty
              ? const Text('Nenhum usuário cadastrado')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      dense: true,
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackgroundColor,
        title: const Text('Resetar Banco de Dados'),
        content: const Text(
          'Isso irá apagar todos os usuários cadastrados e recriar apenas o usuário admin padrão. Deseja continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              await authProvider.resetDatabase();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Banco de dados resetado com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Resetar'),
          ),
        ],
      ),
    );
  }
}