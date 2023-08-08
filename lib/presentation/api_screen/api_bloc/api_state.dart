part of 'api_bloc.dart';

abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoadingState extends ApiState {}

class ApiLoadedState extends ApiState {
  ApiLoadedState({required this.list});
  final List<FetchPostsModel> list;
}

class ApiErrorState extends ApiState {}
