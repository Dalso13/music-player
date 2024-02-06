
import '../../../../core/repeat_state.dart';


abstract interface class RepeatChange {
  RepeatState execute(RepeatState repeatMode);
}