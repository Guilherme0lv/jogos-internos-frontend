import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:projeto_web/controllers/usuario_controller.dart';
import 'package:projeto_web/models/usuario.dart';
import 'package:projeto_web/widgets/dialog/default_dialog_container.dart';
import 'package:projeto_web/widgets/dialog/generic_edit_dialog.dart';

class UsuarioDialog extends StatelessWidget {
  final Usuario usuario;
  UsuarioDialog({super.key, required this.usuario});

  final usuarioController = GetIt.instance<UsuarioController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => GenericEditDialog(
                    titulo: "Editar Usuario",
                    campos: {
                      "Matricula": usuario.matricula,
                      "Senha": usuario.senha,
                      "Nome": usuario.nomeCompleto,
                      "Apelido": usuario.apelido,
                      "Telefone": usuario.telefone,
                      "TipoUsuario": usuario.tipoUsuario,
                      "Curso": usuario.cursoNome,
                    },
                    onSalvar: (valores) async {
                      final atualizado = Usuario(
                        matricula: valores["Matricula"] ?? usuario.matricula,
                        senha: valores["Senha"] ?? usuario.senha,
                        nomeCompleto: valores["Nome"] ?? usuario.nomeCompleto,
                        apelido: valores["Apelido"] ?? usuario.apelido,
                        telefone: valores["Telefone"] ?? usuario.telefone,
                        tipoUsuario:
                            valores["TipoUsuario"] ?? usuario.tipoUsuario,
                        cursoNome: valores["Curso"] ?? usuario.cursoNome,
                      );
                      await usuarioController.updateUser(
                        atualizado,
                        usuario.matricula,
                      );
                    },
                  ),
                );
              },
              child: Text("Editar", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ],
      content: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Informações do Usuario",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            DefaultDialogContainer(
              child: Text(
                "Matricula: ${usuario.matricula}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            DefaultDialogContainer(
              child: Text(
                "Nome: ${usuario.nomeCompleto}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            DefaultDialogContainer(
              child: Text(
                "Apelido: ${usuario.apelido}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            DefaultDialogContainer(
              child: Text(
                "Telefone: ${usuario.telefone}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            DefaultDialogContainer(
              child: Text(
                "Tipo: ${usuario.tipoUsuario}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            DefaultDialogContainer(
              child: Text(
                "Curso: ${usuario.cursoNome}",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
