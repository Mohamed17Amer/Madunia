import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'instructions_state.dart';

class InstructionsCubit extends Cubit<InstructionsState> {
  InstructionsCubit() : super(InstructionsInitial());
}
