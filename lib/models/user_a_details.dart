import 'package:flutter/material.dart';
import 'package:i_service/data/user_a_details.dart';

class UserADetailsScreen extends StatefulWidget {
  final List<UserADetails> userADetails;

  UserADetailsScreen(this.userADetails);

  @override
  _UserADetailsScreenState createState() => _UserADetailsScreenState();
}

class _UserADetailsScreenState extends State<UserADetailsScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _matricNoController = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();

  bool _isAdding = false;
  int _editIndex = -1;

  List<String> serviceList = [
    'Printing',
    'Posting Stuff',
    'Barber',
    'Personal Shopper',
    'Driver',
  ];

  List<IconData> serviceIcons = [
    Icons.print,
    Icons.post_add,
    Icons.cut,
    Icons.shopping_cart,
    Icons.drive_eta,
  ];

  int _selectedServiceIndex = -1;

  Map<String, Color> serviceColors = {
    'Printing': Colors.blue,
    'Posting Stuff': Colors.green,
    'Barber': Colors.red,
    'Personal Shopper': Colors.orange,
    'Driver': Colors.purple,
  };

  Widget _buildServiceIcon(String serviceOffered) {
    Color serviceColor =
        serviceColors[serviceOffered] ?? const Color.fromARGB(255, 40, 15, 6);

    IconData iconData = serviceIcons[serviceList.indexOf(serviceOffered)];

    return CircleAvatar(
      backgroundColor: serviceColor,
      child: Icon(iconData),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
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
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 117, 66, 47), Colors.brown],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAdding = !_isAdding;
                  if (_isAdding) {
                    _clearFields();
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              child: Text(_isAdding ? 'Cancel' : 'Add Details'),
            ),
            _isAdding ? _buildAddDetailsForm() : Container(),
            SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 10,
                child: _buildUserDetailsList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddDetailsForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
            ),
            TextFormField(
              controller: _matricNoController,
              decoration: InputDecoration(labelText: 'Matric No', labelStyle: TextStyle(color: Colors.white)),
            ),
            TextFormField(
              controller: _contactNoController,
              decoration: InputDecoration(labelText: 'Contact No', labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 2),
            Text('Select Service Offered:', style: TextStyle(color: Colors.white),),
            SizedBox(height: 2),
            Wrap(
              spacing: 8.0,
              children: List.generate(
                serviceList.length,
                (index) => ChoiceChip(
                  label: Row(
                    children: [
                      Icon(serviceIcons[index]),
                      SizedBox(width: 4),
                      Text(serviceList[index]),
                    ],
                  ),
                  selected: _selectedServiceIndex == index,
                  onSelected: (selected) {
                    setState(() {
                      _selectedServiceIndex = selected ? index : -1;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addOrUpdateUserDetails();
              },
              child: Text(_editIndex != -1 ? 'Update' : 'Add'),
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 1, 28, 69),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetailsList() {
    return ListView.builder(
      itemCount: widget.userADetails.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(widget.userADetails[index].matricNo),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          onDismissed: (direction) {
            _deleteUserDetails(index);
          },
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(widget.userADetails[index].name),
              subtitle: Text(widget.userADetails[index].matricNo +
                  "\n" +
                  widget.userADetails[index].contactNo),
              leading:
                  _buildServiceIcon(widget.userADetails[index].serviceOffered),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editUserDetails(index, isEditing: true);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _addOrUpdateUserDetails() {
    final String name = _nameController.text;
    final String matricNo = _matricNoController.text;
    final String contactNo = _contactNoController.text;

    setState(() {
      if (_editIndex != -1) {
        widget.userADetails[_editIndex] = UserADetails(
          name: name,
          matricNo: matricNo,
          contactNo: contactNo,
          serviceOffered: _selectedServiceIndex != -1
              ? serviceList[_selectedServiceIndex]
              : '',
          serviceColor: serviceColors[serviceList[_selectedServiceIndex]] ??
              const Color.fromARGB(255, 40, 15, 6),
        );
        _editIndex = -1;
      } else {
        widget.userADetails.add(UserADetails(
          name: name,
          matricNo: matricNo,
          contactNo: contactNo,
          serviceOffered: _selectedServiceIndex != -1
              ? serviceList[_selectedServiceIndex]
              : '',
          serviceColor: serviceColors[serviceList[_selectedServiceIndex]] ??
              const Color.fromARGB(255, 40, 15, 6),
        ));
      }
      _clearFields();
    });
  }

  void _editUserDetails(int index, {bool isEditing = false}) {
    setState(() {
      _editIndex = index;
      if (isEditing) {
        _nameController.text = widget.userADetails[index].name;
        _matricNoController.text = widget.userADetails[index].matricNo;
        _contactNoController.text = widget.userADetails[index].contactNo;
        _selectedServiceIndex =
            serviceList.indexOf(widget.userADetails[index].serviceOffered);
        _isAdding = true;
      }
    });
  }

  void _deleteUserDetails(int index) {
    setState(() {
      widget.userADetails.removeAt(index);
      if (_editIndex == index) {
        _clearFields();
      }
    });
  }

  void _clearFields() {
    _nameController.clear();
    _matricNoController.clear();
    _contactNoController.clear();
    _selectedServiceIndex = -1;
    _editIndex = -1;
  }
}
