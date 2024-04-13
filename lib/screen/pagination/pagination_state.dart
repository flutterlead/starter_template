import 'package:equatable/equatable.dart';

class PaginationBlocState extends Equatable {
  const PaginationBlocState._() : super();

  const PaginationBlocState.initial() : this._();

  PaginationBlocState copyWith() => const PaginationBlocState._();

  @override
  List<Object> get props => [];

  @override
  bool get stringify => true;
}
