import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_poc/data/network_service.dart';
import 'package:sentry_poc/domain/photos_model.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial()) {
    on<FetchApiEvent>((event, emit) async {
      emit(ApiLoadingState());
      var response = await fetchPosts();
      response.fold((l) => Left(emit(ApiErrorState())),
          (r) => Right(emit(ApiLoadedState(list: r))));
    });
  }
}
