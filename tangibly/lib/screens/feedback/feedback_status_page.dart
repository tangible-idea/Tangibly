import 'package:flutter/material.dart';
import 'package:tangibly/models/data_model.dart';
import 'package:tangibly/screens/feedback/project_card_horizontal.dart';
import 'package:tangibly/screens/feedback/project_card_vertical.dart';

class FeedbackStatusPage extends StatelessWidget {
  FeedbackStatusPage({Key? key}) : super(key: key);

  ValueNotifier<bool> _switchGridLayout = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ValueListenableBuilder(
          valueListenable: _switchGridLayout,
          builder: (BuildContext context, _, __) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //change
                crossAxisCount: _switchGridLayout.value ? 2 : 1,
                mainAxisSpacing: 10,

                //change height 125
                mainAxisExtent: _switchGridLayout.value ? 220 : 125,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (_, index) => _switchGridLayout.value
                  ?
              ProjectCardVertical(
                projectName: AppData.productData[index]
                ['projectName'],
                category: AppData.productData[index]['category'],
                color: AppData.productData[index]['color'],
                ratingsUpperNumber: AppData.productData[index]
                ['ratingsUpperNumber'],
                ratingsLowerNumber: AppData.productData[index]
                ['ratingsLowerNumber'],
              )
                  :
              ProjectCardHorizontal(
                projectName: AppData.productData[index]
                ['projectName'],
                category: AppData.productData[index]['category'],
                color: AppData.productData[index]['color'],
                ratingsUpperNumber: AppData.productData[index]
                ['ratingsUpperNumber'],
                ratingsLowerNumber: AppData.productData[index]
                ['ratingsLowerNumber'],
              ),
              itemCount: AppData.productData.length,
            );
          },
        ),
      ),
    );
  }
}
