import 'package:flutter/material.dart';

@immutable
abstract class DataEvent {
  const DataEvent();
}

class Initial extends DataEvent {
  const Initial();
}

class Loading extends DataEvent {
  const Loading();
}

class Error extends DataEvent {
  final Exception exception;

  const Error({required this.exception});

  @override
  String toString() {
    return 'Exception: ${exception.toString()}';
  }
}

class Data<T> extends DataEvent {
  final T data;

  const Data({required this.data});

  @override
  String toString() {
    return 'Data: ${data.toString()}';
  }
}

class Empty extends DataEvent {
  final String message;

  const Empty({required this.message});

  @override
  String toString() {
    return 'Empty: $message';
  }
}
