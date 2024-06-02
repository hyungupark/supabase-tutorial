import "package:flutter/material.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:whose_turn/config.dart";

void main() async {
  await Supabase.initialize(
    url: Config.supabaseUrl,
    anonKey: Config.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> countries = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final List<Map<String, dynamic>> data =
        await supabase.from("countries").select();
    setState(() {
      countries = data;
    });
  }

  void insertData() async {
    await supabase.from("countries").insert({"name": "China"});
    fetchData();
  }

  void updateData() async {
    await supabase
        .from("countries")
        .update({"name": "Japan"}).match({"name": "China"});
    fetchData();
  }

  void deleteData() async {
    await supabase.from("countries").delete().match({"name": "Japan"});
    fetchData();
  }

  void selectEqualTo() async {
    final data = await supabase.from("countries").select().eq("name", "Korea");
    print(data);
  }

  void selectNotEqualTo() async {
    final data =
        await supabase.from("countries").select("name").neq("name", "China");
    print(data);
  }

  void selectGreaterThan() async {
    final data = await supabase.from("countries").select().gt("id", 2);
    print(data);
  }

  void selectGreaterThanOrEqualTo() async {
    final data = await supabase.from("countries").select().gte("id", 2);
    print(data);
  }

  void selectLessThan() async {
    final data = await supabase.from("countries").select().lt("id", 2);
    print(data);
  }

  void selectLessThanOrEqualTo() async {
    final data = await supabase.from("countries").select().lte("id", 2);
    print(data);
  }

  void selectMatchPattern() async {
    final data =
        await supabase.from("countries").select().like("name", "%rea%");
    print(data);
  }

  void selectMatchCaseInsensitivePattern() async {
    final data =
        await supabase.from("countries").select().ilike("name", "%REA%");
    print(data);
  }

  void selectIsValue() async {
    final data =
        await supabase.from("countries").select().isFilter("name", null);
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: countries.length,
        itemBuilder: ((context, index) {
          final Map<String, dynamic> country = countries[index];
          return ListTile(
            title: Text(country["name"] ?? "NULL"),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectIsValue,
      ),
    );
  }
}
