import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/esporte_controller.dart';
import 'package:projeto_web/controllers/grupo_controller.dart';
import 'package:projeto_web/controllers/jogo_controller.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/dto/fase_dto.dart';
import 'package:projeto_web/models/esporte.dart';
import 'package:projeto_web/widgets/campeonatoPage/eliminatorias_view.dart';
import 'package:projeto_web/widgets/campeonatoPage/grupo_view.dart';
import 'package:projeto_web/widgets/custom_drawer.dart';
import 'package:projeto_web/widgets/custom_footer.dart';

class CampeonatoPage extends StatefulWidget {
  const CampeonatoPage({super.key});

  @override
  State<CampeonatoPage> createState() => _CampeonatoPageState();
}

class _CampeonatoPageState extends State<CampeonatoPage> {
  int esporteIndex = 0;
  int faseIndex = 0;

  final List<String> fases = [
    "GRUPO",
    "OITAVASFINAL",
    "QUARTASFINAL",
    "SEMIFINAL",
    "FINAL",
  ];
  final usuarioController = GetIt.I<UsuarioController>();
  final jogoController = GetIt.I<JogoController>();
  final grupoController = GetIt.I<GrupoController>();
  final esporteController = GetIt.I<EsporteController>();

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = usuarioController.usuario?.tipoUsuario == "ADMIN";
    final bool isArbitro = usuarioController.usuario?.tipoUsuario == "ARBITRO";
    final bool canEdit = isAdmin || isArbitro;

    return Scaffold(
      drawer: CustomDrawer(usuario: usuarioController.usuario),
      appBar: AppBar(
        title: const Text("Campeonatos"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Esporte>>(
        future: esporteController.getEsportes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum esporte encontrado"));
          }

          final esportes = snapshot.data!;
          final esporteAtual = esportes[esporteIndex];
          final faseAtual = fases[faseIndex];

          return Column(
            children: [
              //Navegar entre esportes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: esporteIndex > 0
                        ? () => setState(() => esporteIndex--)
                        : null,
                  ),
                  Text(
                    esporteAtual.nome,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: esporteIndex < esportes.length - 1
                        ? () => setState(() => esporteIndex++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //Navegar entre fases
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: faseIndex > 0
                        ? () => setState(() => faseIndex--)
                        : null,
                  ),
                  Text(
                    faseAtual.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: faseIndex < fases.length - 1
                        ? () => setState(() => faseIndex++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(width: 12),
              // Botão para gerar a próxima fase (se aplicável)
              if (canEdit &&
                  (faseAtual == "OITAVASFINAL" ||
                      faseAtual == "QUARTASFINAL" ||
                      faseAtual == "SEMIFINAL"))
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final faseDTO = FaseDTO(
                        nomeEsporte: esporteAtual.nome,
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
                  label: const Text("Gerar próxima Fase"),
                ),

              const SizedBox(width: 12),
              const Divider(),
              Expanded(
                child: faseAtual == "GRUPO"
                    ? CampeonatoGruposView(
                        esporteNome: esporteAtual.nome,
                        canEdit: canEdit,
                        grupoController: grupoController,
                        jogoController: jogoController,
                        onRefresh: () => setState(() {}),
                      )
                    : CampeonatoEliminatoriaView(
                        esporteNome: esporteAtual.nome,
                        fase: faseAtual,
                        canEdit: canEdit,
                        jogoController: jogoController,
                        onRefresh: () => setState(() {}),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
