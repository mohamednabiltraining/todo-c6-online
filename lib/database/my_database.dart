import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_c6_online/database/Task.dart';
import 'package:todo_c6_online/date_utils.dart';

class MyDatabase{

  static CollectionReference<Task> getTasksCollection(){
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(fromFirestore:(snapshot, options) {
      return Task.fromFirestore(snapshot.data()!);
    } , toFirestore: (task,options){
      return task.toFireStore();
    });
  }

  static Future<void> insertTask(Task task){
    var tasksCollection = getTasksCollection();
    var doc = tasksCollection.doc();// create new doc
    task.id = doc.id;
    return doc.set(task);// get Doc -> then set //update
  }

  static Future<QuerySnapshot<Task>> getAllTasks(DateTime selectedDate)async{
    // read Data once
    // query -> filtration
   return await getTasksCollection()
       .where('dateTime',isEqualTo:dateOnly(selectedDate).millisecondsSinceEpoch )// filter
        .get();
  }
  static Stream<QuerySnapshot<Task>>
  listenForTasksRealTimeUpdates(DateTime selectedDate){
    // listen for real time updates
    return getTasksCollection()
        .where('dateTime',isEqualTo: dateOnly(selectedDate).millisecondsSinceEpoch)
        .snapshots();
  }
  static Future<void> deleteTask(Task task){
    var taskDoc = getTasksCollection()
        .doc(task.id);
    return taskDoc.delete();
  }
}