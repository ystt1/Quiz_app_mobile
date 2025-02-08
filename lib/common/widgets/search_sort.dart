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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SearchSortCubit())],
      child: BlocConsumer<SearchSortCubit, SearchAndSortModel>(
        listener: (context, state) {
          print(state);
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
                          setState(() {
                            _isSearchOpen = !_isSearchOpen;
                          });
                          context.read<SearchSortCubit>().clearText();
                        },
                      ),
                      if (_isSearchOpen)
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              context.read<SearchSortCubit>().onGet(
                                  SearchAndSortModel(
                                      name: value,
                                      sortField: state.sortField,
                                      direction: state.direction));
                            },
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                            ),
                            onSubmitted: (value) {
                              // Handle search on Enter

                              setState(() {
                                _isSearchOpen = false;
                              });
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
                    print("Sort Field Selected: $value, New Direction: $newDirection");
                    context.read<SearchSortCubit>().onGet(SearchAndSortModel(
                      name: state.name,
                      sortField: value,
                      direction: newDirection,
                    ));
                  },

                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      value: widget.type == null ? 'name' : 'best',
                      child: ListTile(
                        leading: state.sortField == (widget.type == null ? 'name' : 'best')
                            ? (state.direction == "asc"
                            ? const Icon(Icons.arrow_upward)
                            : const Icon(Icons.arrow_downward))
                            : null,
                        title: Text(widget.type == null ? 'Name' : "Best"),
                      ),
                    ),

                    PopupMenuItem(
                      value: 'createdAt',
                      child: ListTile(
                        leading: state.sortField == "createdAt"
                            ? (state.direction == "asc"
                                ? const Icon(Icons.arrow_upward)
                                : const Icon(Icons.arrow_downward))
                            : null,
                        title: const Text('Date Create'),
                      ),
                    ),
                  ],
                  icon: const Icon(Icons.sort),
                ),
              ]);
        },
      ),
    );
  }
}
