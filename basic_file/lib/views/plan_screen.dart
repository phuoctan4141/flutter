// ignore_for_file: library_private_types_in_public_api, unused_field, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:basic_file/controllers/file_controller.dart';
import 'package:basic_file/models/plan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  late ScrollController scrollController;
  late TextEditingController textController;

  late bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        FocusScope.of(context).requestFocus(FocusNode());
      });

    final filcontroller = Provider.of<FileController>(context, listen: false);

    filcontroller.fetandcreateJsonFile().then((_) => setState(() {}));

    filcontroller.fetandsetPlan().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filcontroller = Provider.of<FileController>(context, listen: false);
    final _plan = filcontroller.plan;

    return Scaffold(
      appBar: AppBar(title: const Text('File Json Demo')),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(children: <Widget>[
              Expanded(child: _buildList(_plan)),
              SafeArea(child: Text(_plan.completenessMessage))
            ])),
      floatingActionButton: _buildAddTaskButton(_plan),
    );
  }

  Widget _buildAddTaskButton(Plan plan) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        createNewTask().then((_) => setState(() {}));
      },
    );
  }

  Widget _buildList(Plan plan) {
    return ListView.builder(
        controller: scrollController,
        itemCount: plan.tasks.length,
        itemBuilder: (context, index) => _buildTaskTile(plan, index));
  }

  Widget _buildTaskTile(Plan plan, index) {
    textController = TextEditingController();
    textController.text = plan.tasks[index].description;

    return ListTile(
      key: ValueKey(plan),
      leading: Checkbox(
          value: plan.tasks[index].complete,
          onChanged: (selected) {
            plan.tasks[index].complete = selected!;
            writeTask(plan).then((_) => setState(() {}));
          }),
      title: TextFormField(
          controller: textController,
          onFieldSubmitted: (text) {
            plan.tasks[index].description = text;
            writeTask(plan).then((_) => setState(() {}));
          }),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          deteteTask(index).then((_) => setState(() {}));
        },
      ),
    );
  }

  Future createNewTask() async {
    final filecontroller = Provider.of<FileController>(context, listen: false);

    await filecontroller.createNewTask();
  }

  Future writeTask(Plan plan) async {
    final filecontroller = Provider.of<FileController>(context, listen: false);

    await filecontroller.writeTask(plan);
  }

  Future deteteTask(index) async {
    final filecontroller = Provider.of<FileController>(context, listen: false);

    await filecontroller.deteteTask(index);
  }
}
