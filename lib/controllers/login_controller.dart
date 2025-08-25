import 'package:flutter/material.dart';
import 'package:projeto_web/dto/login_dto.dart';
import 'package:projeto_web/models/usuario.dart';

import 'package:projeto_web/services/login_service.dart';
import 'package:projeto_web/states/messages_states.dart';

class LoginController extends ChangeNotifier {
  final LoginService loginService;

  LoginController({required this.loginService});

  ValueNotifier<MessagesStates> mensagemNotifier = ValueNotifier(
    IddleMessagesState(),
  );

  Future<Usuario?> login(LoginDTO loginDTO) async {
    try {
      Usuario? usuario = await loginService.login(loginDTO.matricula, loginDTO.senha);

      if (usuario != null) {
        mensagemNotifier.value = SuccessMessage("Login efetuado com sucesso");
        notifyListeners();
      }

      return usuario;
    } catch (e) {
      mensagemNotifier.value = ErrorMessage(e.toString());
      notifyListeners();
      return null;
    }
  }
}
