import 'package:flutter/material.dart';
import 'package:projeto_web/controllers/jogo_controller.dart';
import 'package:projeto_web/dto/fase_dto.dart';

class CampeonatoPageActions extends StatelessWidget {
  final String esporteNome;
  final String faseAtual;
  final JogoController jogoController;
  final bool canEdit;

  const CampeonatoPageActions({
    super.key,
    required this.esporteNome,
    required this.faseAtual,
    required this.jogoController,
    required this.canEdit, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botão Gerar Eliminatória
          if (canEdit)
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  await jogoController.gerarEliminatoria(esporteNome);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Eliminatória gerada com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                
                  (context as Element).markNeedsBuild();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erro ao gerar eliminatória: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Gerar Eliminatória"),
            ),

          const SizedBox(width: 12),

          // Botão Gerar Próxima Fase
          if (canEdit)
            ElevatedButton.icon(
              onPressed: () async {
                try {
                  final faseDTO = FaseDTO(
                    nomeEsporte: esporteNome,
                    faseAtual: faseAtual,
                  );
                  await jogoController.gerarProximaFase(faseDTO);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Próxima fase gerada com sucesso!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                  (context as Element).markNeedsBuild();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erro ao gerar próxima fase: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              icon: const Icon(Icons.navigate_next),
              label: const Text("Próxima Fase"),
            ),
        ],
      ),
    );
  }
}
