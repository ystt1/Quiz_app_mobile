import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';

class SearchSortCubit extends Cubit<SearchAndSortModel> {
  SearchSortCubit():super(SearchAndSortModel(name: '', sortField: "", direction: ""));

  onGet(SearchAndSortModel searchSort)
  {
    emit(searchSort);
  }
  clearText()
  {
    SearchAndSortModel flag=SearchAndSortModel(name: '', sortField: state.sortField, direction: state.direction);
    emit(flag);
  }
}