import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/product/product.dart';
import 'package:shopping_cart/product/product_data_repository.dart';

import '../cart/cart_model.dart';
import '../cart/cart_provider.dart';
import '../cart/cart_screen.dart';
import '../db_helper.dart';

class ProductListScreen extends StatefulWidget {
  final String category;
  const ProductListScreen({Key? key, required this.category}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  DBHelper? dbHelper = DBHelper();
   List<ProductItem> productData = [];
  final TextEditingController txtsearch = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<ProductItem> data = ProductDataProvider().productItems;
  int pageNo = 0;
  int pageSize = 10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterData(widget.category);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent)
      {
        pageNo++;
        filterData(widget.category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart  = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  border: Border.all(

                      color: Colors.grey,
                      style: BorderStyle.solid,
                      width: 1.0),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40.0)),
              child: Column(
                children: <Widget>[

                  GestureDetector(

                    child: Padding(
                      padding: EdgeInsets.only(left: 0.0,),

                      child: TextField(
                        autofocus: false,
                        controller: txtsearch,
                        onChanged: (value) => updateSearchState(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search ',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Montserrat',
                            color: Colors.grey,

                          ),
                          icon:
                          IconButton(
                            icon: Icon(Icons.search, size: 15,),
                            onPressed: (){
                              updateSearchState(txtsearch.text.toString());
                              // MyNavigator.goToSearch(context);
                            },
                          ),
                        ),
                      ),

                    ),
                    // onTap: (){MyNavigator.goToSearch(context);},
                  ),
                ],
              ),

            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: productData.length,
                controller: _scrollController,
                itemBuilder: (context, index){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image(
                            height: 100,
                            width: 100,
                            image: NetworkImage(productData[index].productImage.toString()),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productData[index].productName.toString() ,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5,),
                                Text(productData[index].productUnit.toString() +" "+r"₹ "+ productData[index].productPrice.toString() ,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 5,),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: (){
                                      print(index);
                                      print(index);
                                      print(productData[index].productName.toString());
                                      print( productData[index].productPrice.toString());
                                      print( productData[index].productPrice);
                                      print('1');
                                      print(productData[index].productUnit.toString());
                                      print(productData[index].productImage.toString());

                                      dbHelper!.insert(
                                        Cart(
                                            id: index,
                                            productId: index.toString(),
                                            productName: productData[index].productName.toString(),
                                            initialPrice: productData[index].productPrice,
                                            productPrice: productData[index].productPrice,
                                            quantity: 1,
                                            unitTag: productData[index].productUnit.toString(),
                                            image: productData[index].productImage.toString())
                                      ).then((value){

                                        cart.addTotalPrice(double.parse(productData[index].productPrice.toString()));
                                        cart.addCounter();

                                        final snackBar = SnackBar(backgroundColor: Colors.green,content: Text('Product is added to cart'), duration: Duration(seconds: 1),);

                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                      }).onError((error, stackTrace){
                                        print("error"+error.toString());
                                        final snackBar = SnackBar(backgroundColor: Colors.red ,content: Text('Product is already added in cart'), duration: Duration(seconds: 1));

                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });
                                    },
                                    child:  Container(
                                      height: 35,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: const Center(
                                        child:  Text('Add to cart' , style: TextStyle(color: Colors.white),),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )

                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
          ),

        ],
      ),
    );
  }

  updateSearchState(String text) {
    // latestId = 0;
    // defaultRecordSize = 100;
    if (text.isNotEmpty) {
      setState(() {
        productData = [];
        for (int i = 0; i < data.length; i++)
        {
          String val = data[i].productName;
          if(val.toLowerCase().contains(text.toLowerCase())){
            productData.add(data[i]);
          }
        }
      });
    }
    else if(text.isEmpty){
      setState(() {
        productData = [];
       filterData(widget.category);
      });
    }
  }

  void filterData(String category){
    if(category == "ALL")
      {
        for(int row = (pageNo*pageSize)+1; row <= (pageNo*pageSize)+pageSize; row++)
          {
            if(row <= data.length) {
              productData.add(data[row-1]);
            }
          }
      }
    else {
      for(int row = (pageNo*pageSize)+1; row <= (pageNo*pageSize)+pageSize; row++)
      {
        if(row <= data.length) {
          String val = data[row-1].category;
          if(val.toLowerCase().contains(category.toLowerCase())){
            productData.add(data[row-1]);
          }
        }
      }
      // data.forEach((element) {
      //   category == element.category ? productData.add(element) : productData;
      // });
    }
  }
}




