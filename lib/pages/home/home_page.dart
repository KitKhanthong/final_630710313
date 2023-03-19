import 'package:flutter/material.dart';

import '../../models/poll.dart';
import '../../services/api.dart';
import '../my_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Poll>? polls;
  var _isLoading = false;
  bool _isError = false;
  String _errMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    // todo: Load list of polls here

    setState(() {
      _isLoading = true;
      _isError = false;
    });

    await Future.delayed(const Duration(seconds: 3), () {});

    try {
      var result = await ApiClient().getPolls();
      setState(() {
        polls = result;
      });
    } catch (e) {
      setState(() {
        _errMessage = e.toString();
        _isError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      body: Column(
        children: [
          Image.network('https://cpsu-test-api.herokuapp.com/images/election.jpg'),
          Expanded(
            child: Stack(
              children: [
                if (polls != null) _buildList(),
                if (_isLoading) _buildProgress(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ListView _buildList() {
    return ListView.builder(
      itemCount: polls!.length,
      itemBuilder: (BuildContext context, int index) {
        // todo: Create your poll item by replacing this Container()
        //return Text(polls![index].question);

          /*return Card(
            child: Column(
              children: [
                Text(polls![index].question),
                Column(
                  children: polls![index].choices.map((choice) {
                    return Text(choice);
                  }).toList(),
                ),
              ],
            ),
          );*/
        return Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(polls![index].question),
              ),
              Column(
                children: polls![index].choices.map((choice) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // do something when button is pressed
                            _loadData();
                          },
                          child: Text(
                            choice,
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white, // button color
                          ),
                        ),
                        SizedBox(width: 10.0), // add some spacing between buttons
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );



  }


  Widget _buildProgress() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(color: Colors.white),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('รอสักครู่', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
