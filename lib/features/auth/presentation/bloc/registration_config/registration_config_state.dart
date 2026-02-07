import 'package:equatable/equatable.dart';

abstract class RegistrationConfigState extends Equatable {
  const RegistrationConfigState();

  @override
  List<Object?> get props => [];
}

class RegistrationConfigInitial extends RegistrationConfigState {
  const RegistrationConfigInitial();
}

class RegistrationConfigLoaded extends RegistrationConfigState {
  final bool isOpen;

  const RegistrationConfigLoaded({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}
