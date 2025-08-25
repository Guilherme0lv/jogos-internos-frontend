import 'package:flutter/material.dart';
import 'package:projeto_web/controllers/grupo_controller.dart';
import 'package:projeto_web/controllers/jogo_controller.dart';
import 'package:projeto_web/models/classificacao.dart';
import 'package:projeto_web/models/grupo.dart';
import 'package:projeto_web/models/jogo.dart';
import 'package:projeto_web/widgets/campeonatoPage/jogo_card.dart';

class CampeonatoGruposView extends StatelessWidget {
  final String esporteNome;
  final bool canEdit;
  final GrupoController grupoController;
  final JogoController jogoController;
  final VoidCallback onRefresh;

  const CampeonatoGruposView({
    super.key,
    required this.esporteNome,
    required this.canEdit,
    required this.grupoController,
    required this.jogoController,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Grupo>>(
      future: grupoController.getGruposByEsporte(esporteNome),
      builder: (context, snapshotGrupos) {
        if (snapshotGrupos.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshotGrupos.hasError) {
          return Center(child: Text("Erro: ${snapshotGrupos.error}"));
        }

        final grupos = snapshotGrupos.data!;

        Widget acoesWidget = const SizedBox.shrink();

        if (canEdit) {
          if (!snapshotGrupos.hasData || grupos.isEmpty) {
            acoesWidget = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Nenhum grupo encontrado"),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final novosGrupos = await grupoController.grupoService
                          .gerarGrupos(esporteNome);
                      grupoController.grupos.addAll(novosGrupos);

                      for (var grupo in novosGrupos) {
                        await jogoController.gerarJogos(grupo.nome);
                      }
                      onRefresh(); // Notifica a página pai para reconstruir
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Grupos e jogos gerados com sucesso!",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erro ao gerar grupos: $e"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.group_add),
                  label: const Text("Gerar Grupos"),
                ),
              ],
            );
          } else {
            acoesWidget = ElevatedButton.icon(
              onPressed: () async {
                if (grupos.length == 1) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Número insuficiente de grupos. O primeiro colocado do grupo é o campeão.",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.orange,
                        duration: Duration(seconds: 4),
                      ),
                    );
                  }
                } else {
                  try {
                    await jogoController.gerarEliminatoria(esporteNome);
                    onRefresh();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Eliminatória gerada com sucesso!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
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
                }
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text("Gerar Eliminatória"),
            );
          }
        }
        if (!snapshotGrupos.hasData || grupos.isEmpty) {
          return Center(child: acoesWidget);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: acoesWidget,
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: grupos.length,
                itemBuilder: (context, indexGrupo) {
                  final grupo = grupos[indexGrupo];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grupo ${String.fromCharCode('A'.codeUnitAt(0) + indexGrupo)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth < 600) {
                              return Column(
                                children: [
                                  _buildClassificacaoList(grupo.nome),
                                  const SizedBox(height: 20),
                                  _buildJogosList(grupo.nome, canEdit),
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _buildClassificacaoList(grupo.nome),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: _buildJogosList(grupo.nome, canEdit),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        const Divider(height: 40, thickness: 2),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildClassificacaoList(String grupoNome) {
    return FutureBuilder<List<Classificacao>>(
      future: grupoController.getClassificacao(grupoNome),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Erro ao carregar classificação: ${snapshot.error}");
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            "Nenhuma classificação encontrada para este grupo.",
          );
        }

        final classificacoes = snapshot.data!;
        return DataTable(
          columnSpacing: 10,
          horizontalMargin: 10,
          columns: const [
            DataColumn(
              label: Text(
                'Pos.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Equipe',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text('Pts', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('V', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text('D', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
          rows: classificacoes.map((c) {
            return DataRow(
              cells: [
                DataCell(Text(c.posicao.toString())),
                DataCell(Text(c.nomeEquipe)),
                DataCell(Text(c.pontos.toString())),
                DataCell(Text(c.vitorias.toString())),
                DataCell(Text(c.derrotas.toString())),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildJogosList(String grupoNome, bool canEdit) {
    return FutureBuilder<List<Jogo>>(
      future: jogoController.getJogosByGrupo(grupoNome),
      builder: (context, snapshotJogos) {
        if (snapshotJogos.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshotJogos.hasError) {
          return Center(child: Text("Erro: ${snapshotJogos.error}"));
        }
        if (!snapshotJogos.hasData || snapshotJogos.data!.isEmpty) {
          return const SizedBox();
        }

        final jogos = snapshotJogos.data!;
        return Column(
          children: jogos
              .map(
                (jogo) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: JogoCard(
                    jogo: jogo,
                    jogoController: jogoController,
                    onRefresh: () => onRefresh(), // Passa a função de refresh
                    canEdit: canEdit,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
