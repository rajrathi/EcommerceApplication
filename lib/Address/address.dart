import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shyamshopee/Config/config.dart';
import 'package:shyamshopee/Models/address.dart';
import 'package:shyamshopee/Orders//placeOrder.dart';
import 'package:shyamshopee/Widgets/customAppBar.dart';
import 'package:shyamshopee/Widgets/loadingWidget.dart';
import 'package:shyamshopee/Widgets/wideButton.dart';
import 'package:shyamshopee/Counters/changeAddresss.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addAddress.dart';

class Address extends StatefulWidget
{
  final double totalAmount;
  const Address({Key key, this.totalAmount}) : super(key: key);
  @override
  _AddressState createState() => _AddressState();
}


class _AddressState extends State<Address>
{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: MyAppBar(),
       body: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisSize: MainAxisSize.min,
         children: [
           Align(
             alignment: Alignment.centerLeft,
             child: Padding(
               padding: EdgeInsets.all(8.0),
               child: Text(
                 "Select Address",
                 style: GoogleFonts.aBeeZee(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
               ),
             ),
           ),
           Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: ECommerce.firestore
                  .collection(ECommerce.collectionUser)
                  .document(ECommerce.sharedPreferences.getString(ECommerce.userUID))
                  .collection(ECommerce.subCollectionAddress).snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ?Center(child: circularProgress(),)
                    : snapshot.data.documents.length == 0
                    ? noAddressCard()
                    : ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return AddressCard(
                        currentIndex: address.numberOfAddress,
                        value: index,
                        addressId: snapshot.data.documents[index].documentID,
                        totalAmount: widget.totalAmount,
                        model: AddressModel.fromJson(snapshot.data.documents[index].data),
                      );
                    }
                );
              },
            )
           );
           }),
         ],
       ),
       floatingActionButton: FloatingActionButton.extended(
         label: Text("Add new Address"),
         backgroundColor: Colors.redAccent[400],
         icon: Icon(Icons.add_location),
         onPressed: (){
           Route route = MaterialPageRoute(builder: (c) => AddAddress());
           Navigator.pushReplacement(context, route);
         },
       ),
      ),
    );
  }

  noAddressCard() {
    return Card(
      color: Colors.pink.withOpacity(0.4),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location, color: Colors.white,),
            Text("No shipping address added yet"),
            Text("Please add shipping address."),
          ],
        )
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressModel model;
  final int currentIndex;
  final String addressId;
  final double totalAmount;
  final int value;

  AddressCard({Key key, this.model, this.currentIndex, this.addressId, this.totalAmount, this.value}):super(key: key);

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<AddressChanger>(context, listen: false).displayResult(widget.value);
      },
      child: Card(
        color: Colors.indigo[900].withOpacity(0.4),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.pink,
                  onChanged: (val) {
                    Provider.of<AddressChanger>(context, listen: false).displayResult(val);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: screenWidth * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              KeyText(msg: "Name"),
                              Text(widget.model.name),
                            ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Phone"),
                                Text(widget.model.phoneNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Flat/House Number"),
                                Text(widget.model.flatNumber),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "City"),
                                Text(widget.model.city),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "State"),
                                Text(widget.model.state),
                              ]
                          ),
                          TableRow(
                              children: [
                                KeyText(msg: "Pin Code"),
                                Text(widget.model.pincode),
                              ]
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            widget.value == Provider.of<AddressChanger>(context).numberOfAddress
            ? WideButton(
                msg: "Proceed",
                onPressed: (){
                  Route route = MaterialPageRoute(builder: (c) =>PaymentPage(
                    addressId: widget.addressId,
                    totalAmount: widget.totalAmount,
                  ));
                  Navigator.push(context, route);
                },
            ) : Container()
          ],
        ),
      ),
    );
  }
}





class KeyText extends StatelessWidget {
  final String msg;
  KeyText({Key key, this.msg}):super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      msg,
      style: GoogleFonts.aBeeZee(color: Colors.black, fontWeight: FontWeight.bold),
    );
  }
}
