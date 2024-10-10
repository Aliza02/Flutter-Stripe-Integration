import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/api/api.dart';
import 'package:stripe/bloc/events.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentStatus> {
  PaymentBloc() : super(PaymentStatus.initial) {
    on<ProcessPayment>(
      (event, emit) async {
        emit(PaymentStatus.loading);
        bool status = await makePayment();
        if (status) {
          emit(PaymentStatus.success);
        } else {
          emit(PaymentStatus.error);
        }
      },
    );
  }
}
