import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/common/bloc/search_sort/search_sort_cubit.dart';
import 'package:quiz_app/data/question/models/search_sort_model.dart';

class SearchSort extends StatefulWidget {
  final String? type;
  final Function(SearchAndSortModel state) onSearch;
  const SearchSort({super.key, required this.onSearch, this.type});

  @override
  State<SearchSort> createState() => _SearchSortState();
}

class _SearchSortState extends State<SearchSort> {
  bool _isSearchOpen = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SearchSortCubit())],
      child: BlocConsumer<SearchSortCubit, SearchAndSortModel>(
        listener: (context, state) {
          widget.onSearch(state);
        },
        builder: (BuildContext context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isSearchOpen ? 300 : 48,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(_isSearchOpen ? Icons.close : Icons.search),
                      onPressed: () {
                        setState(() => _isSearchOpen = !_isSearchOpen);
                        if (!_isSearchOpen) {
                          _controller.clear();
                          context.read<SearchSortCubit>().clearText();
                        }
                      },
                    ),
                    if (_isSearchOpen)
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              context.read<SearchSortCubit>().onGet(
                                SearchAndSortModel(
                                    name: value,
                                    sortField: state.sortField,
                                    direction: state.direction),
                              );
                            } else {
                              setState(() => _isSearchOpen = false);
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  final newDirection = (value == state.sortField)
                      ? (state.direction == 'desc' ? 'asc' : 'desc')
                      : 'desc';
                  context.read<SearchSortCubit>().onGet(SearchAndSortModel(
                    name: state.name,
                    sortField: value,
                    direction: newDirection,
                  ));
                },
                itemBuilder: (BuildContext context) => [
                  _buildMenuItem(
                      value: widget.type == null ? 'name' : 'best',
                      title: widget.type == null ? 'Name' : "Best",
                      state: state),
                  _buildMenuItem(
                      value: 'createdAt', title: 'Date Create', state: state),
                ],
                icon: const Icon(Icons.sort),
              ),
            ],
          );
        },
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String title,
    required SearchAndSortModel state,
  }) {
    return PopupMenuItem(
      value: value,
      child: ListTile(
        leading: state.sortField == value
            ? Icon(state.direction == "desc"
            ? Icons.arrow_upward
            : Icons.arrow_downward)
            : null,
        title: Text(title),
      ),
    );
  }
}
