import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/live/live_bloc.dart';
=======
import 'package:infyapp/screens/tabs/call_page.dart';
>>>>>>> fcf35d4 (first change)

class LiveTab extends StatefulWidget {
  const LiveTab({super.key});

  @override
  State<LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends State<LiveTab> {
<<<<<<< HEAD
  @override
  void initState() {
    super.initState();
    context.read<LiveBloc>().add(CheckLiveStatus());
=======
  final textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _submit() {
    if (textEditingController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CallPage(callId: textEditingController.text.trim()),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a valid ID")));
    }
>>>>>>> fcf35d4 (first change)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Streaming"),
        backgroundColor: Colors.red,
      ),
<<<<<<< HEAD
      body: BlocBuilder<LiveBloc, LiveState>(
        builder: (context, state) {
          if (state.isLive) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("LIVE NOW 🚀"),
                  Text("Meeting ID: ${state.meetingId}"),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LiveBloc>().add(EndLive());
                    },
                    child: const Text("End Live"),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<LiveBloc>().add(StartLive("USER_ID_HERE"));
                },
                child: const Text("Go Live"),
              ),
            );
          }
        },
=======
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  labelText: "Enter your ID to join",
                  hintText: "Type here...",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Submit")),
            ],
          ),
        ),
>>>>>>> fcf35d4 (first change)
      ),
    );
  }
}
