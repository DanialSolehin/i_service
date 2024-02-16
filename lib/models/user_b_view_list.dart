import 'package:flutter/material.dart';
import 'package:i_service/data/user_a_details.dart';

class UserBViewListScreen extends StatelessWidget {
  final List<UserADetails> userADetails;

  UserBViewListScreen(this.userADetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        backgroundColor: Colors.brown,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/download.png'),
              radius: 20,
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: userADetails.length,
        itemBuilder: (context, index) {
          UserADetails currentUser = userADetails[index];

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(currentUser.name),
              subtitle:
                  Text(currentUser.matricNo + "\n" + currentUser.contactNo),
              leading: CircleAvatar(
                backgroundColor: currentUser.serviceColor,
                child: _buildServiceIcon(currentUser.serviceOffered),
              ),
              onTap: () {
                _showUserADetails(context, currentUser);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceIcon(String serviceOffered) {
    IconData iconData;
    switch (serviceOffered) {
      case 'Printing':
        iconData = Icons.print;
        break;
      case 'Posting Stuff':
        iconData = Icons.post_add;
        break;
      case 'Barber':
        iconData = Icons.cut;
        break;
      case 'Personal Shopper':
        iconData = Icons.shopping_cart;
        break;
      case 'Driver':
        iconData = Icons.drive_eta;
        break;
      default:
        iconData = Icons.error;
    }
    return Icon(iconData);
  }

  void _showUserADetails(BuildContext context, UserADetails userADetails) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: userADetails.serviceColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    userADetails.serviceOffered,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'NAME: ${userADetails.name}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'MATRIC NO: ${userADetails.matricNo}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'CONTACT NO: ${userADetails.contactNo}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
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
