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

  void selectInArray() async {
    final data = await supabase
        .from("countries")
        .select()
        .inFilter("name", ["Korea", "Japan"]);
    print(data);
  }

  void containsEveryElementInValue() async {
    final data = await supabase
        .from("issues")
        .select()
        .contains("tags", ["is:open", "priority:low"]);
    print(data);
  }

  void containedByValue() async {
    final data = await supabase
        .from("classes")
        .select("name")
        .containedBy("days", ["monday", "tuesday", "wednesday", "friday"]);
    print(data);
  }

  void greaterThanARange() async {
    final data = await supabase
        .from("reservations")
        .select()
        .rangeGt("during", "[2000-01-02 08:00, 2000-01-02 09:00)");
    print(data);
  }

  void greaterThanOrEqualToARange() async {
    final data = await supabase
        .from("reservations")
        .select()
        .rangeGte("during", "[2000-01-02 08:30, 2000-01-02 09:30)");
    print(data);
  }

  void lessThanARange() async {
    final data = await supabase
        .from("reservations")
        .select()
        .rangeLt("during", "[2000-01-01 15:00, 2000-01-01 16:00)");
    print(data);
  }

  void lessThanOrEqualToARange() async {
    final data = await supabase
        .from("reservations")
        .select()
        .rangeLte("during", "[2000-01-01 15:00, 2000-01-01 16:00)");
    print(data);
  }

  void mutuallyExclusiveToARange() async {
    final data = await supabase
        .from("reservations")
        .select()
        .rangeAdjacent("during", "[2000-01-01 12:00, 2000-01-01 13:00)");
    print(data);
  }

  void withACommonElement() async {
    final data = await supabase
        .from("issues")
        .select("title")
        .overlaps("tags", ["is:closed", "severity:high"]);
    print(data);
  }

  void matchAString() async {
    final data = await supabase
        .from("texts")
        .select("content")
        .textSearch("content", "'eggs' & 'ham'", config: "english");
    print(data);
  }

  void matchAnAssociatedValue() async {
    final data = await supabase
        .from("countries")
        .select()
        .match({"id": 4, "name": "Korea"});
    print(data);
  }

  void dontMatchTheFilter() async {
    final data =
        await supabase.from("countries").select().not("name", "is", null);
    print(data);
  }

  void matchAtLeastOneFilter() async {
    final data = await supabase
        .from("countries")
        .select("name")
        .or("id.eq.2,name.eq.Algeria");
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
        onPressed: matchAtLeastOneFilter,
      ),
    );
  }
}
