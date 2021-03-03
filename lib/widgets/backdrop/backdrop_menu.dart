import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../generated/l10n.dart';
import '../../models/entities/listing_location.dart';
import '../../models/index.dart'
    show
        AppModel,
        Category,
        TagModel,
        CategoryModel,
        FilterAttributeModel,
        ProductModel;
import '../../models/listing/listing_location_model.dart';
import '../../services/service_config.dart';
import '../common/tree_view.dart';
import '../layout/adaptive.dart';
import 'category_item.dart';
import 'filter_option_item.dart';
import 'location_item.dart';

class BackdropMenu extends StatefulWidget {
  final Function onFilter;
  final String categoryId;
  final String tagId;
  final String listingLocationId;

  const BackdropMenu({
    Key key,
    this.onFilter,
    this.categoryId,
    this.tagId,
    this.listingLocationId,
  }) : super(key: key);

  @override
  _BackdropMenuState createState() => _BackdropMenuState();
}

class _BackdropMenuState extends State<BackdropMenu> {
  double mixPrice = 0.0;
  double maxPrice = kMaxPriceFilter / 2;
  String categoryId = '-1';
  String tagId = '-1';
  String currentSlug;
  String listingLocationId;
  int currentSelectedAttr = -1;

  @override
  void initState() {
    super.initState();
    categoryId = widget.categoryId;
    tagId = widget.tagId;
    listingLocationId = widget.listingLocationId;
  }

  @override
  Widget build(BuildContext context) {
    final category = Provider.of<CategoryModel>(context);
    final tag = Provider.of<TagModel>(context);
    final selectLayout = Provider.of<AppModel>(context).productListLayout;
    final currency = Provider.of<AppModel>(context).currency;
    final currencyRate = Provider.of<AppModel>(context).currencyRate;
    final filterAttr = Provider.of<FilterAttributeModel>(context);

    List<ListingLocation> locations;
    if (Config().isListingType()) {
      locations =
          Provider.of<ListingLocationModel>(context, listen: false).locations;
      listingLocationId = Provider.of<ProductModel>(context).listingLocationId;
    }
    categoryId = Provider.of<ProductModel>(context).categoryId;

    Function _onFilter =
        (categoryId, tagId, {listingLocationId}) => widget.onFilter(
              minPrice: mixPrice,
              maxPrice: maxPrice,
              categoryId: categoryId,
              tagId: tagId,
              attribute: currentSlug,
              currentSelectedTerms: filterAttr.lstCurrentSelectedTerms,
              listingLocationId: listingLocationId ?? this.listingLocationId,
            );

    return ListenableProvider.value(
      value: category,
      child: Consumer<CategoryModel>(
        builder: (context, catModel, _) {
          if (catModel.isLoading) {
            printLog('Loading');
            return Center(child: Container(child: kLoadingWidget(context)));
          }

          if (catModel.categories != null) {
            final categories = catModel.categories
                .where((item) => item.parent == '0')
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  isDisplayDesktop(context)
                      ? SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(width: 20),
                              GestureDetector(
                                child: const Icon(Icons.arrow_back_ios,
                                    size: 22, color: Colors.white70),
                                onTap: () {
                                  if (isDisplayDesktop(context)) {
                                    eventBus
                                        .fire(const EventOpenCustomDrawer());
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(width: 20),
                              Text(
                                S.of(context).products,
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),

                  Padding(
                    padding: const EdgeInsets.only(left: 15, top: 30),
                    child: Text(
                      S.of(context).byCategory.toUpperCase(),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(3.0)),
                      child: TreeView(
                        parentList: [
                          for (var item in categories)
                            Parent(
                              parent: CategoryItem(
                                item,
                                hasChild:
                                    hasChildren(catModel.categories, item.id),
                                isSelected: item.id == categoryId,
                                onTap: (category) => _onFilter(category, tagId),
                              ),
                              childList: ChildList(
                                children: [
                                  Parent(
                                    parent: CategoryItem(
                                      item,
                                      isLast: true,
                                      isParent: true,
                                      isSelected: item.id == categoryId,
                                      onTap: (category) =>
                                          _onFilter(category, tagId),
                                    ),
                                    childList: ChildList(
                                      children: const [],
                                    ),
                                  ),
                                  for (var category in getSubCategories(
                                      catModel.categories, item.id))
                                    Parent(
                                        parent: CategoryItem(
                                          category,
                                          isLast: true,
                                          isSelected: category.id == categoryId,
                                          onTap: (category) =>
                                              _onFilter(category, tagId),
                                        ),
                                        childList: ChildList(
                                          children: const [],
                                        ))
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (Config().isListingType())
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 30),
                      child: Text(
                        S.of(context).location.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  if (Config().isListingType())
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(3.0)),
                        child: Column(
                          children: List.generate(
                            locations.length,
                            (index) => LocationItem(
                              locations[index],
                              isSelected:
                                  locations[index].id == listingLocationId,
                              onTap: () {
                                _onFilter(categoryId, tagId,
                                    listingLocationId: locations[index].id);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (!Config().isListingType()) ...[
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        S.of(context).byPrice.toUpperCase(),
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          Tools.getCurrencyFormatted(mixPrice, currencyRate,
                              currency: currency),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const Text(
                          " - ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          Tools.getCurrencyFormatted(maxPrice, currencyRate,
                              currency: currency),
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.white,
                              ),
                        )
                      ],
                    ),
                    SliderTheme(
                      data: const SliderThemeData(
                        activeTrackColor: Color(kSliderActiveColor),
                        inactiveTrackColor: Color(kSliderInactiveColor),
                        activeTickMarkColor: Colors.white70,
                        inactiveTickMarkColor: Colors.white,
                        overlayColor: Colors.white12,
                        thumbColor: Color(kSliderActiveColor),
                        showValueIndicator: ShowValueIndicator.always,
                      ),
                      child: RangeSlider(
                        min: 0.0,
                        max: kMaxPriceFilter,
                        divisions: kFilterDivision,
                        values: RangeValues(mixPrice, maxPrice),
                        onChanged: (RangeValues values) {
                          setState(() {
                            mixPrice = values.start;
                            maxPrice = values.end;
                          });
                        },
                      ),
                    ),
                    ListenableProvider.value(
                      value: filterAttr,
                      child: Consumer<FilterAttributeModel>(
                        builder: (context, value, child) {
                          if (value.lstProductAttribute != null) {
                            List<Widget> list = List.generate(
                              value.lstProductAttribute.length,
                              (index) {
                                return FilterOptionItem(
                                  enabled: !value.isLoading,
                                  onTap: () {
                                    currentSelectedAttr = index;

                                    currentSlug =
                                        value.lstProductAttribute[index].slug;
                                    value.getAttr(
                                        id: value
                                            .lstProductAttribute[index].id);
                                  },
                                  title: value.lstProductAttribute[index].name
                                      .toUpperCase(),
                                  isValid: currentSelectedAttr != -1,
                                  selected: currentSelectedAttr == index,
                                );
                              },
                            );

                          }
                          return Container();
                        },
                      ),
                    ),
                  ],
                ]

                  ..addAll([
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 30,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonTheme(
                              height: 50,
                              child: RaisedButton(
                                elevation: 0.0,
                                color: Colors.white70,
                                onPressed: () => _onFilter(categoryId, tagId),
                                child: Text(
                                  S.of(context).apply,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                  ]),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  bool hasChildren(categories, id) {
    return categories.where((o) => o.parent == id).toList().length > 0;
  }

  List<Category> getSubCategories(categories, id) {
    return categories.where((o) => o.parent == id).toList();
  }
}
