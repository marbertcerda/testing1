import 'package:flutter/material.dart';
import 'package:testing/exports.dart';

final searchProvider = StateProvider<String>((ref) => '');
final bottomNavProvider = StateProvider<int>((ref) => 0);

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hello,',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
                    icon: const Icon(Icons.menu_rounded),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      currentUser!.displayName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.w200,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Visibility(
                    visible: ref.watch(searchProvider).isNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchProvider.notifier).state = '';
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                onChanged: (value) {
                  ref.read(searchProvider.notifier).state = value;
                },
              ),
              const SizedBox(height: 8),
              NoteListView(
                query: ref.watch(searchProvider),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: const CreateNoteView(
                    mode: NoteMode.create,
                  ),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
