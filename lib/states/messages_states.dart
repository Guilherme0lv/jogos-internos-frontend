abstract class MessagesStates {}

class IddleMessagesState extends MessagesStates {}

class SuccessMessage extends MessagesStates {
  final String message;

  SuccessMessage(this.message);
}

class ErrorMessage extends MessagesStates {
  final String message;

  ErrorMessage(this.message);
}