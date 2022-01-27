import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/product/product_list.dart';

import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import 'category_item.dart';
import 'category_repository.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<CategoryItem> categoryItems = CategoryDataProvider().categoryItems;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen()));
            },
            child: Center(
              child: Badge(
                showBadge: true,
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value , child){
                    return Text(value.getCounter().toString(),style: TextStyle(color: Colors.white));
                  },
                ),
                animationType: BadgeAnimationType.fade,
                animationDuration: Duration(milliseconds: 300),
                child: Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),

          SizedBox(width: 20.0)
        ],
      ),
      body: Column(
        children: [
          _getEvents
        ],
      ),
    );
  }
  get _getEvents{
    return GridView.builder(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: categoryItems.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation ==
            Orientation.landscape ? 3: 2,
        childAspectRatio: (2 / 2),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context,index,) {
        return GestureDetector(
          onTap:(){
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListScreen(category: categoryItems[index].categoryName,)));
          },
          child:Container(
            child: Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child:
                    Image.network(categoryItems[index].categoryImage)
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Text(categoryItems[index].categoryName, style:TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
