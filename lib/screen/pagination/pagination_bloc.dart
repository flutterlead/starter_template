import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:starter_template/injectable/injectable.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:starter_template/screen/pagination/pagination_state.dart';
import 'package:starter_template/services/web_service/api_service.dart';

class PaginationBloc extends Cubit<PaginationBlocState> {
  late final PagingController<int, PeopleModel> _pagingController;
  late int limit;

  PaginationBloc() : super(const PaginationBlocState.initial()) {
    limit = 20;
    _pagingController = PagingController<int, PeopleModel>(firstPageKey: 1);
    _pagingController.addPageRequestListener((pageKey) => _fetchPage(pageKey));
  }

  PagingController<int, PeopleModel> get pageController => _pagingController;

  void refresh() => pageController.refresh();

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getIt<RestClient>().getPeoples();
      final isLastPage = newItems.length < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Future<void> close() {
    _pagingController.dispose();
    return super.close();
  }
}
