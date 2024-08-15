import "dart:async";

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_supabase/config.dart";
import 'package:google_sign_in/google_sign_in.dart';
import "package:supabase_flutter/supabase_flutter.dart";

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

  @override
  void initState() {
    super.initState();
    listenToAuthEvents();
  }

  void fetchData() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select("name");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void insertData() async {
    final dynamic data =
        await supabase.from("countries").insert({"name": "Japan"});
    debugPrint(data);
  }

  void updateData() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .update({"name": "China"})
        .eq("id", 5)
        .select();
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void upsertData() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .upsert({"id": 1, "name": "Albania"}).select();
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void deleteData() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").delete().eq("id", 1).select();
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsEqualToAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().eq("name", "Japan");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsNotEqualToAValue() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select("id, name")
        .neq("name", "Japan");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsGreaterThanAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().gt("id", 2);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsGreaterThanOrEqualToAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().gte("id", 2);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsLessThanAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().lt("id", 2);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsLessThanOrEqualToAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().lte("id", 2);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnMatchesAPattern() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().like("name", "%apa%");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnMatchesACaseInsensitivePattern() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().ilike("name", "%aPa%");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsAValue() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().isFilter("name", null);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnIsInAnArray() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select()
        .inFilter("name", ["Korea", "Japan"]);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void columnContainsEveryElementInAValue() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("issues")
        .select()
        .contains("tags", ["is:open", "priority:low"]);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void containedByValue() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("classes")
        .select("name")
        .containedBy("days", ["monday", "tuesday", "wednesday", "friday"]);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void greaterThanARange() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("reservations")
        .select()
        .rangeGt("during", "[2000-01-02 08:00, 2000-01-02 09:00)");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void greaterThanOrEqualToARange() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("reservations")
        .select()
        .rangeGte("during", "[2000-01-02 08:30, 2000-01-02 09:30)");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void lessThanARange() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("reservations")
        .select()
        .rangeLt("during", "[2000-01-01 15:00, 2000-01-01 16:00)");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void lessThanOrEqualToARange() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("reservations")
        .select()
        .rangeLte("during", "[2000-01-01 15:00, 2000-01-01 16:00)");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void mutuallyExclusiveToARange() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("reservations")
        .select()
        .rangeAdjacent("during", "[2000-01-01 12:00, 2000-01-01 13:00)");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void withACommonElement() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("issues")
        .select("title")
        .overlaps("tags", ["is:closed", "severity:high"]);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void matchAString() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("texts")
        .select("content")
        .textSearch("content", "\"eggs\" & \"ham\"", config: "english");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void matchAnAssociatedValue() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select()
        .match({"id": 11, "name": "Japan"});
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void doNotMatchTheFilter() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select().not("name", "is", null);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void matchAtLeastOneFilter() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select("id, name")
        .or("id.eq.11,name.eq.Korea");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void matchTheFilter() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select()
        .filter("name", "in", "(\"Korea\",\"Japan\")");
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void returnDataAfterInserting() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .upsert({"id": 1, "name": "Algeria"}).select();
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void orderTheResults() async {
    final List<Map<String, dynamic>> dataList = await supabase
        .from("countries")
        .select("id, name")
        .order("id", ascending: false);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void limitTheNumberOfRowsReturned() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select("name").limit(1);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void limitTheQueryToARange() async {
    final List<Map<String, dynamic>> dataList =
        await supabase.from("countries").select("name").range(0, 1);
    for (Map<String, dynamic> data in dataList) {
      debugPrint("name: ${data["name"]}");
    }
  }

  void retrieveOneRowOfData() async {
    final Map<String, dynamic> data =
        await supabase.from("countries").select("name").limit(1).single();
    debugPrint("name: ${data["name"]}");
  }

  void retrieveZeroOrOneRowOfData() async {
    final Map<String, dynamic>? data = await supabase
        .from("countries")
        .select()
        .eq("name", "Singapore")
        .maybeSingle();
    debugPrint("name: ${data?["name"] ?? "null"}");
  }

  void retrieveAsACSV() async {
    final dynamic data = await supabase.from('countries').select().csv();
    debugPrint(data);
  }

  void usingExplain() async {
    final String data = await supabase.from("countries").select().explain();
    debugPrint(data);
  }

  void createANewUser() async {
    final AuthResponse res = await supabase.auth.signUp(
      email: Config.email,
      password: Config.password,
    );
    final Session? session = res.session;
    final User? user = res.user;
    debugPrint("{ session: ${session ?? "null"}, user: ${user ?? "null"} }");
  }

  void listenToAuthEvents() async {
    final StreamSubscription<AuthState> authSubscription =
        supabase.auth.onAuthStateChange.listen((AuthState data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      debugPrint('event: $event, session: $session');

      switch (event) {
        case AuthChangeEvent.initialSession:
          // handle initial session
          debugPrint("AuthChangeEvent.initialSession");
        case AuthChangeEvent.signedIn:
          // handle signed in
          debugPrint("AuthChangeEvent.signedIn");
        case AuthChangeEvent.signedOut:
          // handle signed out
          debugPrint("AuthChangeEvent.signedOut");
        case AuthChangeEvent.passwordRecovery:
          // handle password recovery
          debugPrint("AuthChangeEvent.passwordRecovery");
        case AuthChangeEvent.tokenRefreshed:
          // handle token refreshed
          debugPrint("AuthChangeEvent.tokenRefreshed");
        case AuthChangeEvent.userUpdated:
          // handle user updated
          debugPrint("AuthChangeEvent.userUpdated");
        case AuthChangeEvent.userDeleted:
          // handle user deleted
          debugPrint("AuthChangeEvent.userDeleted");
        case AuthChangeEvent.mfaChallengeVerified:
          // handle mfa challenge verified
          debugPrint("AuthChangeEvent.mfaChallengeVerified");
      }
    });
  }

  void createAnAnonymousUser() async {
    final AuthResponse res = await supabase.auth.signInAnonymously();
    final Session? session = res.session;
    final User? user = res.user;
    debugPrint("{ session: ${session ?? "null"}, user: ${user ?? "null"} }");
  }

  void signInAUser() async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: Config.email,
      password: Config.password,
    );
    final Session? session = res.session;
    final User? user = res.user;
    debugPrint("{ session: ${session ?? "null"}, user: ${user ?? "null"} }");
  }

  void signInWithIdToken() async {
    const String webClientId = Config.webClientId;
    const String iosClientId = Config.iosClientId;

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final String? accessToken = googleAuth.accessToken;
    final String? idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final AuthResponse response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final Session? session = response.session;
    final User? user = response.user;
    debugPrint("{ session: ${session ?? "null"}, user: ${user ?? "null"} }");
  }

  void signInAUserThroughOTP() async {
    await supabase.auth.signInWithOtp(
      email: Config.email,
      emailRedirectTo: kIsWeb ? null : Config.signInCallback,
    );
  }

  void signInAUserThroughOAuth() async {
    final bool result =
        await supabase.auth.signInWithOAuth(OAuthProvider.github);
    debugPrint(result.toString());
  }

  void signInAUserThroughSSO() async {
    final bool result = await supabase.auth.signInWithSSO(
      domain: Config.domain,
    );
    debugPrint(result.toString());
  }

  void signOutAUser() async {
    await supabase.auth.signOut();
  }

  void verifyAndLogInThroughOTP() async {
    final AuthResponse res = await supabase.auth.verifyOTP(
      type: OtpType.signup,
      token: Config.token,
      phone: Config.phone,
    );
    final Session? session = res.session;
    final User? user = res.user;
    debugPrint("{ session: ${session ?? "null"}, user: ${user ?? "null"} }");
  }

  void retrieveASession() async {
    final Session? session = supabase.auth.currentSession;
    debugPrint("session: ${session ?? "null"}");
  }

  void retrieveANewSession() async {
    final AuthResponse res = await supabase.auth.refreshSession();
    final Session? session = res.session;
    debugPrint("session: ${session ?? "null"}");
  }

  void retrieveAUser() async {
    final User? user = supabase.auth.currentUser;
    debugPrint("user: ${user ?? "null"}");
  }

  void updateAUser() async {
    final UserResponse res = await supabase.auth.updateUser(
      UserAttributes(
        email: Config.email,
      ),
    );
    final User? updatedUser = res.user;
    debugPrint("user: ${updatedUser ?? "null"}");
  }

  void retrieveIdentitiesLinkedToAUser() async {
    final List<UserIdentity> identities =
        await supabase.auth.getUserIdentities();
    for (UserIdentity identity in identities) {
      debugPrint("""
        { 
          identity.id: ${identity.id}, 
          identity.identityId: ${identity.identityId}, 
          identity.userId: ${identity.userId},
        }
      """);
    }
  }

  void linkAnIdentityToAUser() async {
    final bool data = await supabase.auth.linkIdentity(OAuthProvider.google);
    debugPrint(data.toString());
  }

  void unlinkAnIdentityFromAUser() async {
    // retrieve all identites linked to a user
    final List<UserIdentity> identities =
        await supabase.auth.getUserIdentities();

    // find the google identity
    final UserIdentity googleIdentity = identities.firstWhere(
      (element) => element.provider == "google",
    );
    debugPrint("""
      { 
        googleIdentity.id: ${googleIdentity.id}, 
        googleIdentity.identityId: ${googleIdentity.identityId}, 
        googleIdentity.userId: ${googleIdentity.userId},
      }
    """);

    // unlink the google identity
    await supabase.auth.unlinkIdentity(googleIdentity);
  }

  void sendAPasswordReauthenticationNonce() async {
    await supabase.auth.reauthenticate();
  }

  void resendAnOTP() async {
    final ResendResponse res = await supabase.auth.resend(
      type: OtpType.email,
      email: Config.email,
    );
    debugPrint(res.messageId ?? "null");
  }

  void setTheSessionData() async {
    final String refreshToken =
        supabase.auth.currentSession?.refreshToken ?? "";
    final AuthResponse response = await supabase.auth.setSession(refreshToken);
    final Session? session = response.session;
    debugPrint("session: ${session ?? "null"}");
  }

  void enrollAFactor() async {
    final AuthMFAEnrollResponse res =
        await supabase.auth.mfa.enroll(factorType: FactorType.totp);
    final String qrCodeUrl = res.totp.qrCode;
    debugPrint(qrCodeUrl);
  }

  void createAChallenge() async {
    final AuthMFAChallengeResponse res = await supabase.auth.mfa.challenge(
      factorId: Config.factorId,
    );
    debugPrint("res.id: ${res.id}");
    debugPrint("res.expiresAt: ${res.expiresAt}");
  }

  void verifyAChallenge() async {
    final AuthMFAVerifyResponse res = await supabase.auth.mfa.verify(
      factorId: Config.factorId,
      challengeId: Config.challengeId,
      code: Config.code,
    );
    debugPrint("res.user.id: ${res.user.id}");
    debugPrint("res.user.email: ${res.user.email}");
  }

  void createAndVerifyAChallenge() async {
    final AuthMFAVerifyResponse res =
        await supabase.auth.mfa.challengeAndVerify(
      factorId: Config.factorId,
      code: Config.code,
    );
    debugPrint("res.user.id: ${res.user.id}");
    debugPrint("res.user.email: ${res.user.email}");
  }

  void unenrollAFactor() async {
    final AuthMFAUnenrollResponse res = await supabase.auth.mfa.unenroll(
      Config.factorId,
    );
    debugPrint("res.id: ${res.id}");
  }

  void getAuthenticatorAssuranceLevel() async {
    final AuthMFAGetAuthenticatorAssuranceLevelResponse res =
        supabase.auth.mfa.getAuthenticatorAssuranceLevel();
    final AuthenticatorAssuranceLevels? currentLevel = res.currentLevel;
    debugPrint("currentLevel.name: ${currentLevel?.name ?? "null"}");
    final AuthenticatorAssuranceLevels? nextLevel = res.nextLevel;
    debugPrint("nextLevel.name: ${nextLevel?.name ?? "null"}");
    final List<AMREntry> currentAuthenticationMethods =
        res.currentAuthenticationMethods;
    for (AMREntry currentAuthenticationMethod in currentAuthenticationMethods) {
      debugPrint(
          "currentAuthenticationMethod.method: ${currentAuthenticationMethod.method}");
    }
  }

  void authAdmin() async {
    final SupabaseClient supabase =
        SupabaseClient(Config.supabaseUrl, Config.serviceRoleKey);
    final User? user = supabase.auth.currentUser;
    debugPrint("user.id: ${user?.id ?? "null"}");
  }

  void adminRetrieveAUser() async {
    final UserResponse res =
        await supabase.auth.admin.getUserById(Config.userId);
    final User? user = res.user;
    debugPrint("user.id: ${user?.id ?? "null"}");
  }

  void listAllUsers() async {
    // Returns the first 50 users.
    final List<User> users = await supabase.auth.admin.listUsers();
    for (User user in users) {
      debugPrint("user.id: ${user.id}");
    }
  }

  void createAUser() async {
    final UserResponse res =
        await supabase.auth.admin.createUser(AdminUserAttributes(
      email: Config.email,
      password: Config.password,
      userMetadata: {'name': 'Yoda'},
    ));
    final User? user = res.user;
    debugPrint("user.id: ${user?.id ?? "null"}");
    debugPrint("user.email: ${user?.email ?? "null"}");
  }

  void deleteAUser() async {
    await supabase.auth.admin.deleteUser(Config.userId);
  }

  void sendAnEmailInviteLink() async {
    final UserResponse res =
        await supabase.auth.admin.inviteUserByEmail(Config.email);
    final User? user = res.user;
    debugPrint("user.id: ${user?.id ?? "null"}");
    debugPrint("user.email: ${user?.email ?? "null"}");
  }

  void generateAnEmailLink() async {
    final GenerateLinkResponse res = await supabase.auth.admin.generateLink(
      type: GenerateLinkType.signup,
      email: Config.email,
      password: Config.password,
    );
    final String actionLink = res.properties.actionLink;
    debugPrint("actionLink: $actionLink");
  }

  void adminUpdateAUser() async {
    await supabase.auth.admin.updateUserById(
      Config.userId,
      attributes: AdminUserAttributes(
        email: Config.email,
      ),
    );
  }

  void invokesASupabaseEdgeFunction() async {
    final FunctionResponse res = await supabase.functions.invoke(
      "hello",
      body: {"foo": "baa"},
    );
    final dynamic data = res.data;
    debugPrint(data);
  }

  void listenToDatabaseChanges() async {
    supabase.from("countries").stream(primaryKey: ["id"]).listen(
      (List<Map<String, dynamic>> dataList) {
        // Do something awesome with the data
        for (Map<String, dynamic> data in dataList) {
          debugPrint("name: ${data["name"]}");
        }
      },
    );
  }

  void subscribeToChannel() async {
    supabase
        .channel("public:countries")
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "countries",
            callback: (payload) {
              debugPrint("Change received: ${payload.toString()}");
            })
        .subscribe();
    supabase
        .channel("room1")
        .onBroadcast(
            event: "cursor-pos",
            callback: (payload) {
              debugPrint("Cursor position received: $payload");
            })
        .subscribe();
  }

  void unsubscribeFromAChannel() async {
    final RealtimeChannel channel = supabase
        .channel("public:countries")
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "countries",
            callback: (payload) {
              debugPrint("Change received: ${payload.toString()}");
            })
        .subscribe();
    final String status = await supabase.removeChannel(channel);
    debugPrint("status: $status");
  }

  void unsubscribeFromAllChannels() async {
    final List<String> statuses = await supabase.removeAllChannels();
    for (String status in statuses) {
      debugPrint("status: $status");
    }
  }

  void retrieveAllChannels() async {
    final List<RealtimeChannel> channels = supabase.getChannels();
    for (RealtimeChannel channel in channels) {
      channel
          .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: "public",
              table: "countries",
              callback: (payload) {
                debugPrint("Change received: ${payload.toString()}");
              })
          .onBroadcast(
              event: "cursor-pos",
              callback: (payload) {
                debugPrint("Cursor position received: $payload");
              })
          .subscribe();
    }
  }

  void createABucket() async {
    final String bucketId = await supabase.storage.createBucket("avatars");
    debugPrint("bucketId: $bucketId");
  }

  void retrieveABucket() async {
    final Bucket bucket = await supabase.storage.getBucket("avatars");
    debugPrint("bucket.id: ${bucket.id}");
    debugPrint("bucket.name: ${bucket.name}");
  }

  void listAllBuckets() async {
    final List<Bucket> buckets = await supabase.storage.listBuckets();
    for (Bucket bucket in buckets) {
      print("bucket.id: ${bucket.id}");
      print("bucket.name: ${bucket.name}");
    }
  }

  void updateABucket() async {
    final String res = await supabase.storage
        .updateBucket("avatars", const BucketOptions(public: false));
    print("res: $res");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: updateABucket,
      ),
    );
  }
}
