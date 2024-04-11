import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pizza_repository/pizza_repository.dart';

part 'get_pizza_event.dart';
part 'get_pizza_state.dart';

class GetPizzaBloc extends Bloc<GetPizzaEvent, GetPizzaState> {
  final PizzaRepo _PizzaRepo;

  GetPizzaBloc(this._PizzaRepo) : super(GetPizzaInitial()) {
    on<GetPizza>((event, emit) async {
      emit(GetPizzaLoading());
      try {
        List<Pizza> pizzas = await _PizzaRepo.getPizzas();
        emit(GetPizzaSuccess(pizzas));
      } catch (e) {
        emit(GetPizzaFailure());
      }
    });
  }
}
