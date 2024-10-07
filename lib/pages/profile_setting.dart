import 'package:audiopin_frontend/main.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'discover.dart';
import 'library.dart';
import 'pins.dart';
import 'setting.dart';

class ProfileSettingPage extends StatefulWidget  {
  @override
  _ProfileSettingPageState createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFCFCFF),
            title: Text(
              "Profile Settings",
              style: TextStyle(
                fontFamily: 'EuclidCircularA',
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  print("Info pressed");
                },
              ),
            ],
          ),
          backgroundColor: Color(0xFFFCFCFF),
          body: ProfileSettingBody(),
        )
    );
  }
}

class ProfileSettingBody extends StatefulWidget  {
  @override
  _ProfileSettingBodyState createState() => _ProfileSettingBodyState();
}


class _ProfileSettingBodyState extends State<ProfileSettingBody> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Makes the content scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding around the form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First Section Title
              Text(
                'Personal Information',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0), // Space between title and form

              // First Card wrapping the input fields
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name Label and Input Field
                        Text(
                          'First Name',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your first name'
                          ),
                        ),
                        SizedBox(height: 12.0), // Space between fields

                        // Last Name Label and Input Field
                        Text(
                          'Last Name',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your last name'
                          ),
                        ),
                        SizedBox(height: 12.0), // Space between fields

                        // Email Address Label and Input Field
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your email address'
                          ),
                          keyboardType: TextInputType.emailAddress, // Email input type
                        ),
                        SizedBox(height: 12.0), // Space between fields

                        // Date of Birth Label and Input Field
                        Text(
                          'Date of Birth',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your DoB'
                          ),
                          keyboardType: TextInputType.datetime, // Date input type
                        ),
                        SizedBox(height: 30.0), // Space between card and button

                        // Update Button
                        SizedBox(
                          width: double.infinity, // Make the button fill the width
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle the update action here
                              if (_formKey.currentState!.validate()) {
                                // Perform form submission
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0), // Optional: Make the border rounded
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 12.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20.0), // Space between the first and second card

              // Second identical section
              Text(
                'Security',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0), // Space between title and form

              // Second Card wrapping the input fields
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First Name Label and Input Field
                        Text(
                          'Enter Current Password',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your password'
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 12.0), // Space between fields

                        // Last Name Label and Input Field
                        Text(
                          'New Password',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your password'
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 12.0), // Space between fields

                        // Email Address Label and Input Field
                        Text(
                          'Re-enter New Password',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                              hintText: 'Enter your password'
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress, // Email input type
                        ),
                        SizedBox(height: 30.0), // Space between fields

                        // Update Button
                        SizedBox(
                          width: double.infinity, // Make the button fill the width
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle the update action here
                              if (_formKey.currentState!.validate()) {
                                // Perform form submission
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0), // Optional: Make the border rounded
                              ),
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(fontSize: 12.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

void main() =>
    runApp(MaterialApp(
      home: SettingPage(),
    ));
