import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/live/live_bloc.dart';

class LiveTab extends StatefulWidget {
  const LiveTab({super.key});

  @override
  State<LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends State<LiveTab> {
  @override
  void initState() {
    super.initState();
    context.read<LiveBloc>().add(CheckLiveStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Streaming"),
        backgroundColor: Colors.red,
      ),
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
      ),
    );
  }
}
