import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';

class SearchSortCubit extends Cubit<SearchAndSortModel> {
  SearchSortCubit()
      : super(SearchAndSortModel(name: '', sortField: "", direction: "desc"));

  onGet(SearchAndSortModel searchSort) {
    if (searchSort.name == state.name &&
        searchSort.sortField == state.sortField &&
        searchSort.direction == state.direction) return;

    emit(SearchAndSortModel(
      name: searchSort.name,
      sortField: searchSort.sortField.isNotEmpty ? searchSort.sortField : state.sortField,
      direction: searchSort.direction.isNotEmpty ? searchSort.direction : state.direction,
    ));
  }

  clearText() {
    if (state.name.isEmpty) return;

    emit(SearchAndSortModel(
      name: '',
      sortField: state.sortField,
      direction: state.direction,
    ));
  }
}
