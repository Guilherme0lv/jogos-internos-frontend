import 'package:flutter/material.dart';
import 'package:projeto_web/dto/placar_dto.dart';
import '../../models/jogo.dart';
import '../../controllers/jogo_controller.dart';

class JogoDialog extends StatefulWidget {
  final Jogo jogo;
  final JogoController jogoController;
  final VoidCallback onRefresh;

  const JogoDialog({
    super.key,
    required this.jogo,
    required this.jogoController,
    required this.onRefresh,
  });

  @override
  State<JogoDialog> createState() => _JogoDialogState();
}

class _JogoDialogState extends State<JogoDialog> {
  final TextEditingController placarAController = TextEditingController();
  final TextEditingController placarBController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    placarAController.text = widget.jogo.placarEquipeA.toString();
    placarBController.text = widget.jogo.placarEquipeB.toString();
  }

  @override
  void dispose() {
    placarAController.dispose();
    placarBController.dispose();
    super.dispose();
  }

  Future<void> finalizarJogo() async {
    setState(() => isLoading = true);
    try {
      final placarDTO = PlacarDTO(
        idJogo: widget.jogo.id,
        placarA: int.parse(placarAController.text),
        placarB: int.parse(placarBController.text),
      );
      await widget.jogoController.finalizarJogo(placarDTO);
      widget.onRefresh();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> aplicarWO(String nomeVencedor) async {
    setState(() => isLoading = true);
    try {
      await widget.jogoController.aplicarWO(widget.jogo.id, nomeVencedor);
      widget.onRefresh();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> desfazerWO() async {
    setState(() => isLoading = true);
    try {
      await widget.jogoController.desfazerWO(widget.jogo.id);
      widget.onRefresh();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ações do Jogo"),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.jogo.nomeEquipeA} x ${widget.jogo.nomeEquipeB}"),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: placarAController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Placar A"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: placarBController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(labelText: "Placar B"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: desfazerWO,
          child: const Text("Desfazer WO"),
        ),
        TextButton(
          onPressed: () => aplicarWO(widget.jogo.nomeEquipeA),
          child: Text("${widget.jogo.nomeEquipeA} vence WO"),
        ),
        TextButton(
          onPressed: () => aplicarWO(widget.jogo.nomeEquipeB),
          child: Text("${widget.jogo.nomeEquipeB} vence WO"),
        ),
        ElevatedButton(
          onPressed: finalizarJogo,
          child: const Text("Finalizar Jogo"),
        ),
      ],
    );
  }
}
