import 'package:flutter/material.dart';
import 'package:todo_c6_online/database/Task.dart';
import 'package:todo_c6_online/database/my_database.dart';
import 'package:todo_c6_online/date_utils.dart';
import 'package:todo_c6_online/dialogeUtils.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*.7,
      padding: EdgeInsets.all(12),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Add New Task',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,),
            TextFormField(
              controller: titleController,
              validator: (text){
                // return error if exist or null if there is no error
                if(text==null|| text.trim().isEmpty){
                  return 'please enter title';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Title'
              ),
            ),
            SizedBox(height: 12,),
            TextFormField(
              controller: descController,
              validator: (text){
                if(text==null||text.trim().isEmpty){
                  return 'please enter description';
                }
                return null;
              },
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 4,
              minLines: 4,
              decoration: InputDecoration(
                labelText: 'Description'
              ),
            ),
            SizedBox(height: 12,),
            Text('Select Date',
              style: Theme.of(context).textTheme.titleMedium,),
            InkWell(
              onTap: (){
                showDateDialoge();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('${selectedDate.year}/${selectedDate.month}/'
                    '${selectedDate.day}',
                  style: Theme.of(context).textTheme.titleSmall,),
              ),
            ),
            ElevatedButton(onPressed: (){
              addTask();
            }, child: Text('Submit'))
          ],
        ),
      ),
    );
  }
  DateTime selectedDate= DateTime.now();
  void showDateDialoge()async{
    DateTime? date = await showDatePicker(context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if(date!=null){
      setState(() {
        selectedDate = date;
      });
    }
  }

  void addTask(){
    if(formKey.currentState?.validate() == true){
      String title = titleController.text;
      String desc = descController.text;
      Task task = Task(
        title: title,
        description: desc,
        dateTime: dateOnly(selectedDate),
        isDone: false);
      showLoading(context, 'Loading...',isCancelable: false);
      MyDatabase.insertTask(task)
      .then((value) {
        hideLoading(context);
        // called when future is completed
        // show message
        showMessage(context, 'Task added successfully',
        posActionName: 'ok',
        posAction: (){
          Navigator.pop(context);
        });
      }).onError((error, stackTrace){
        // called when future fails
        hideLoading(context);
        showMessage(context, 'something went wrong, try again later');
      }).timeout(Duration(seconds: 5),
      onTimeout: (){
        hideLoading(context);
        showMessage(context, 'task saved locally');
        // save changes in cache
      });

    }
  }
}
