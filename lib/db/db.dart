import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

  var supabase;
  Future<void> dbConnect() async {
    // print('start');
    await Supabase.initialize(
        url: dotenv.get('SUPABASEURL'),
        anonKey: dotenv.get('SUPABASEKEY')
    ).then((onValue) {
      // print(onValue);
      supabase = Supabase.instance.client;
    }).catchError((onError) {
      // print(onError);
    });
    // print('connected');
  }

  Future dbInsert(String modelName, model) async {
    var data = await supabase.from(modelName).insert(
      model,
    ).select();
    // print(data);
    return data;
  }

Future dbGetAll({required String modelName, String columns = '*'}) async {
    var data=await supabase
        .from(modelName)
        .select(columns);
  return data;
}

Future dbGetOne({required String modelName,required int id,String columns='*'}) async {
  var data =await supabase
      .from(modelName)
      .select(columns)
      .eq('id', id)
      .single();

  return data;
}

Future dbUpdate({required String modelName, required int id, required updates})
async{
  var data=await supabase
      .from(modelName)
      .update(updates)
      .eq('id', id)
      .select();


  return data;

}


Future dbDeleteItem({required String modelName, required int id,})
async{

var data = await supabase
    .from(modelName)
    .delete()
    .eq('id', id);


// print (data);
return true;

}

Future dbSearch ({required String modelName, required String searchQuery ,columns='*' }) async {


  var data= await supabase
      .from(modelName)
  .select(columns).or(
  "title.ilike.%${searchQuery}%,description.ilike.%${searchQuery}%"
  );

  return data;

}
