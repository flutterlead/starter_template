import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:starter_template/model/people_model/people.dart';
import 'package:starter_template/screen/pagination/pagination_bloc.dart';
import 'package:starter_template/utils/custom_theme_color/custom_theme_color.dart';
import 'package:starter_template/utils/extension.dart';
import 'package:starter_template/utils/shimmer/shimmer.dart';

class PaginationExample extends StatelessWidget {
  const PaginationExample({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PaginationBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Example'),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => bloc.refresh()),
        child: PagedListView<int, PeopleModel>(
          pagingController: bloc.pageController,
          builderDelegate: PagedChildBuilderDelegate<PeopleModel>(
            noItemsFoundIndicatorBuilder: (context) => const Center(
              child: Text('No item found'),
            ),
            itemBuilder: (context, item, index) => beerListItem(item),
            firstPageProgressIndicatorBuilder: (context) => Column(
              children: List.generate(20, (index) => index)
                  .map<Widget>((e) => shimmerTileWidget(context))
                  .toList(),
            ),
            newPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.all(16.0),
              child: const CupertinoActivityIndicator(),
            ),
          ),
        ),
      ),
    );
  }

  Widget beerListItem(PeopleModel beer) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          beer.avatar.toString(),
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          height: 50,
        ),
      ),
      title: Text(beer.name.toString()),
      subtitle: Text(
        beer.createdAt.toString(),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget shimmerTileWidget(BuildContext context) {
    final myColors = Theme.of(context).extension<CustomThemeColor>()!;
    return Shimmer.fromColors(
      baseColor: myColors.shimmerBaseColor,
      highlightColor: myColors.shimmerHighlightColor,
      enabled: true,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            width: 50,
            height: 50,
            color: Colors.white,
          ),
        ),
        title: Container(
          height: 12.0,
          margin: EdgeInsets.only(right: context.width / 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          height: 12.0,
        ),
      ),
    );
  }
}
