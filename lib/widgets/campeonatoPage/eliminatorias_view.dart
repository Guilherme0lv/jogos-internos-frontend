import 'package:flutter/material.dart';
import 'package:projeto_web/controllers/jogo_controller.dart';
import 'package:projeto_web/models/jogo.dart';
import 'package:projeto_web/widgets/campeonatoPage/jogo_card.dart';


class CampeonatoEliminatoriaView extends StatelessWidget {
  final String esporteNome;
  final String fase;
  final bool canEdit;
  final JogoController jogoController;
  final VoidCallback onRefresh;

  const CampeonatoEliminatoriaView({
    super.key,
    required this.esporteNome,
    required this.fase,
    required this.canEdit,
    required this.jogoController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Jogo>>(
      future: jogoController.getJogosByFase(esporteNome, fase),
      builder: (context, snapshotJogos) {
        if (snapshotJogos.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshotJogos.hasError) {
          return Center(child: Text("Erro: ${snapshotJogos.error}"));
        }
        if (!snapshotJogos.hasData || snapshotJogos.data!.isEmpty) {
          return const Center(child: Text("Nenhum jogo encontrado"));
        }

        final jogos = snapshotJogos.data!;
        return ListView.builder(
          itemCount: jogos.length,
          itemBuilder: (context, index) {
            final jogo = jogos[index];
            return Center(
              child: JogoCard(
                jogo: jogo,
                jogoController: jogoController,
                onRefresh: () => onRefresh(), 
                canEdit: canEdit,
              ),
            );
          },
        );
      },
    );
  }
}
