import 'package:flutter/material.dart';
import 'package:projeto_web/widgets/dialog/jogo_dialog.dart';
import '../../models/jogo.dart';
import '../../controllers/jogo_controller.dart';

class JogoCard extends StatelessWidget {
  final Jogo jogo;
  final JogoController jogoController;
  final VoidCallback onRefresh;
  final bool canEdit; // novo parâmetro

  const JogoCard({
    super.key,
    required this.jogo,
    required this.jogoController,
    required this.onRefresh,
    required this.canEdit, // obrigatório
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Text(
              "${jogo.nomeEquipeA} ${jogo.placarEquipeA} x ${jogo.placarEquipeB} ${jogo.nomeEquipeB}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "${jogo.status} - ${jogo.dataHora}",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            // --- Ícone de menu só se canEdit for true ---
            if (canEdit)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => JogoDialog(
                        jogo: jogo,
                        jogoController: jogoController,
                        onRefresh: onRefresh,
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
