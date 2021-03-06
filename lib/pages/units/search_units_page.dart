import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentalku/commons/colors.dart';
import 'package:rentalku/commons/routes.dart';
import 'package:rentalku/commons/styles.dart';
import 'package:rentalku/models/unit.dart';
import 'package:rentalku/providers/search_units_provider.dart';
import 'package:rentalku/widgets/filter_widget.dart';
import 'package:rentalku/widgets/rental_mobil_card_widget.dart';

class SearchUnitsPage extends StatelessWidget {
  const SearchUnitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchUnitsProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            splashRadius: 24,
            icon: Icon(Icons.chevron_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Rental Mobil"),
          titleTextStyle: AppStyle.title3Text.copyWith(color: Colors.white),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          elevation: 2,
        ),
        body: Builder(
          builder: (context) => ListView.builder(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            itemCount: 10,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: UnitCardWidget(
                unit: Unit(
                  id: 1,
                  name: "Toyota Avanza",
                  description: "Mini MPV",
                  withDriver: true,
                  imageURL: 'https://i.imgur.com/vtUhSMq.png',
                  price: 280000,
                  rating: 4.2,
                  capacity: 6,
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.detailUnit,
                  );
                },
              ),
            ),
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            child: Icon(Icons.filter_alt),
            mini: true,
            backgroundColor: AppColor.green,
            onPressed: () {
              var parentState =
                  Provider.of<SearchUnitsProvider>(context, listen: false);

              showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                builder: (context) =>
                    ChangeNotifierProvider<SearchUnitsProvider>.value(
                  value: parentState,
                  child: ModalSheetBar(context),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget ModalSheetBar(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
      children: [
        Text("Pilihan Kota", style: AppStyle.regular2Text),
        SizedBox(height: 2),
        Consumer<SearchUnitsProvider>(
          builder: (context, state, _) => GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 3,
            children: List.generate(
              state.selectableCity.length,
              (index) => FilterWidget(
                label: state.selectableCity[index],
                selected: state.cities.contains(state.selectableCity[index]),
                onTap: (status) {
                  if (status) {
                    state.cities.add(state.selectableCity[index]);
                  } else {
                    state.cities.remove(state.selectableCity[index]);
                  }
                  state.notifyListeners();
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text("Urutkan menurut", style: AppStyle.regular2Text),
        SizedBox(height: 2),
        Consumer<SearchUnitsProvider>(
          builder: (context, state, _) => GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 3,
            children: List.generate(
              state.selectableSort.length,
              (index) => FilterWidget(
                label: state.selectableSort[index],
                selected: state.sort == state.selectableSort[index],
                onTap: (status) {
                  if (status) {
                    state.sort = state.selectableSort[index];
                  } else {
                    state.sort = state.selectableSort[index];
                  }
                  state.notifyListeners();
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text("Kapasitas penumpang", style: AppStyle.regular2Text),
        SizedBox(height: 2),
        Consumer<SearchUnitsProvider>(
          builder: (context, state, _) => GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 3,
            children: List.generate(
              state.selectableCapacity.length,
              (index) => FilterWidget(
                label: state.selectableCapacity[index],
                selected:
                    state.capacity.contains(state.selectableCapacity[index]),
                onTap: (status) {
                  if (status) {
                    state.capacity.add(state.selectableCapacity[index]);
                  } else {
                    state.capacity.remove(state.selectableCapacity[index]);
                  }
                  state.notifyListeners();
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text("Jenis mobil", style: AppStyle.regular2Text),
        SizedBox(height: 2),
        Consumer<SearchUnitsProvider>(
          builder: (context, state, _) => GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 3,
            children: List.generate(
              state.selectableCarType.length,
              (index) => FilterWidget(
                label: state.selectableCarType[index],
                selected:
                    state.carType.contains(state.selectableCarType[index]),
                onTap: (status) {
                  if (status) {
                    state.carType.add(state.selectableCarType[index]);
                  } else {
                    state.carType.remove(state.selectableCarType[index]);
                  }
                  state.notifyListeners();
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: Text("Cari"),
        ),
      ],
    );
  }
}
