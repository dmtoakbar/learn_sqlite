import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learn_sqllite/splash/bloc/splash_events.dart';
import 'package:learn_sqllite/splash/bloc/splash_states.dart';

class SplashBloc extends Bloc<SplashEvents, SplashStates> {
   SplashBloc():super(const SplashStates()) {
    on<SplashIndex>(_splashIndex);
  }
  void _splashIndex(SplashIndex event, Emitter<SplashStates> emit) {
     emit(state.copyWith(index: event.index));
  }
}