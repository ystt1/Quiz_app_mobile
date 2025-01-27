import 'package:flutter/material.dart';

class SearchSort extends StatefulWidget {
  const SearchSort({super.key});

  @override
  State<SearchSort> createState() => _SearchSortState();
}

class _SearchSortState extends State<SearchSort> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchOpen = false;

  @override
  Widget build(BuildContext context) {
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
                    if (_isSearchOpen) {
                      _searchController.clear();
                    }
                    _isSearchOpen = !_isSearchOpen;
                  });
                },
              ),
              if (_isSearchOpen)
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    onSubmitted: (value) {
                      // Xử lý tìm kiếm khi người dùng nhấn Enter
                      print("Search: $value");
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
            // Handle sort selection
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(value: 'name', child: Text('Sort by Name')),
            const PopupMenuItem(value: 'date', child: Text('Sort by Created Date')),
          ],
          icon: const Icon(Icons.sort),
        ),

      ],
    );
  }
}
