import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GurudwaraApp());
}

const green = Color(0xFF155443);
const gold = Color(0xFFD8AE49);

class GurudwaraApp extends StatefulWidget {
  const GurudwaraApp({super.key});
  @override
  State<GurudwaraApp> createState() => _GurudwaraAppState();
}

class _GurudwaraAppState extends State<GurudwaraApp> {
  Locale locale = const Locale('pa');
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Gurudwara Shri Singh Sabha Bhirdana',
    locale: locale,
    supportedLocales: const [Locale('pa'), Locale('hi'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: green),
      scaffoldBackgroundColor: const Color(0xFFF8F7F1), useMaterial3: true),
    home: HomePage(onLocale: (v) => setState(() => locale = v), locale: locale),
  );
}

String tr(Locale l, String key) {
  const values = {
    'title': {'pa':'ਗੁਰਦੁਆਰਾ ਸ਼੍ਰੀ ਸਿੰਘ ਸਭਾ ਭਿਰਡਾਨਾ','hi':'गुरुद्वारा श्री सिंह सभा भिरडाना','en':'Gurudwara Shri Singh Sabha Bhirdana'},
    'hukam': {'pa':'ਹੁਕਮਨਾਮਾ','hi':'हुकमनामा','en':'Hukamnama'},
    'live': {'pa':'ਲਾਈਵ ਕੀਰਤਨ','hi':'लाइव कीर्तन','en':'Live Kirtan'},
    'events': {'pa':'ਸਮਾਗਮ','hi':'कार्यक्रम','en':'Events'},
    'sewa': {'pa':'ਸੇਵਾ ਅਤੇ ਦਾਨ','hi':'सेवा और दान','en':'Sewa & Donation'},
    'expenses': {'pa':'ਖਰਚਿਆਂ ਦਾ ਰਿਕਾਰਡ','hi':'खर्चों का रिकॉर्ड','en':'Expense Records'},
    'gallery': {'pa':'ਫੋਟੋ ਗੈਲਰੀ','hi':'फोटो गैलरी','en':'Photo Gallery'},
    'contact': {'pa':'ਸੰਪਰਕ','hi':'संपर्क','en':'Contact'},
    'about': {'pa':'ਸਾਡੇ ਬਾਰੇ','hi':'हमारे बारे में','en':'About'},
    'admin': {'pa':'ਐਡਮਿਨ ਪੈਨਲ','hi':'एडमिन पैनल','en':'Admin Panel'},
    'settings': {'pa':'ਸੈਟਿੰਗ','hi':'सेटिंग','en':'Settings'},
  };
  return values[key]?[l.languageCode] ?? values[key]?['en'] ?? key;
}

class HomePage extends StatelessWidget {
  final void Function(Locale) onLocale;
  final Locale locale;
  const HomePage({super.key, required this.onLocale, required this.locale});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('hukam', Icons.menu_book, const HukamnamaPage()),
      ('live', Icons.play_circle_fill, const LivePage()),
      ('events', Icons.event, const EventsPage()),
      ('sewa', Icons.volunteer_activism, const DonationPage()),
      ('expenses', Icons.receipt_long, const ExpensesPage()),
      ('gallery', Icons.photo_library, const GalleryPage()),
      ('contact', Icons.call, const ContactPage()),
      ('about', Icons.info_outline, const AboutPage()),
      ('admin', Icons.admin_panel_settings, const AdminPage()),
      ('settings', Icons.settings, SettingsPage(onLocale: onLocale, locale: locale)),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(tr(locale, 'title')), backgroundColor: green,
        foregroundColor: Colors.white, actions: [
          PopupMenuButton<String>(icon: const Icon(Icons.language), onSelected: (v) =>
            onLocale(Locale(v)), itemBuilder: (_) => const [
              PopupMenuItem(value: 'pa', child: Text('ਪੰਜਾਬੀ')),
              PopupMenuItem(value: 'hi', child: Text('हिंदी')),
              PopupMenuItem(value: 'en', child: Text('English')),
            ]),
        ]),
      body: ListView(children: [
        Container(color: green, padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
          child: const Column(children: [
            Icon(Icons.temple_buddhist, size: 58, color: gold),
            SizedBox(height: 12),
            Text('ਵਾਹਿਗੁਰੂ ਜੀ ਕਾ ਖਾਲਸਾ, ਵਾਹਿਗੁਰੂ ਜੀ ਕੀ ਫਤਹਿ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 17)),
            SizedBox(height: 6),
            Text('Bhirdana, Haryana', style: TextStyle(color: Colors.white70)),
          ])),
        Padding(padding: const EdgeInsets.all(12), child: GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1.2, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return Card(child: InkWell(borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => item.$3)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(item.$2, size: 38, color: green), const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(tr(locale, item.$1), textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
              ])));
          })),
      ]),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  final Widget child;
  const SimplePage({super.key, required this.title, required this.child});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)),
    body: Padding(padding: const EdgeInsets.all(16), child: child));
}

class HukamnamaPage extends StatelessWidget {
  const HukamnamaPage({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Hukamnama', child:
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('hukamnamas').orderBy('date', descending: true).limit(10).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return const Text('Could not load Hukamnama. Please try again later.');
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (snap.data!.docs.isEmpty) return const Text('Hukamnama will be published here by the committee.');
        return ListView(children: snap.data!.docs.map((d) {
          final x = d.data();
          return Card(child: ListTile(title: Text(x['title'] ?? 'Hukamnama'),
            subtitle: Text('${x['text'] ?? ''}\n${x['meaning'] ?? ''}')));
        }).toList());
      }));
}

class LivePage extends StatelessWidget {
  const LivePage({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Live Kirtan', child:
    StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('settings').doc('public').snapshots(),
      builder: (context, snap) {
        final url = snap.data?.data()?['youtubeLiveUrl'] as String? ?? '';
        return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.live_tv, size: 70, color: green),
          const SizedBox(height: 12),
          const Text('Watch the Gurudwara YouTube live stream'),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: url.isEmpty ? null : () => launchUrl(Uri.parse(url),
            mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.play_arrow), label: const Text('Open YouTube Live')),
          if (url.isEmpty) const Padding(padding: EdgeInsets.all(12),
            child: Text('The committee must add the official YouTube Live URL in settings/public.')),
        ]));
      }));
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Events', child:
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('events').orderBy('date').snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return const Text('Could not load events.');
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (snap.data!.docs.isEmpty) return const Text('Upcoming events will appear here.');
        return ListView(children: snap.data!.docs.map((d) {
          final x = d.data();
          return Card(child: ListTile(leading: const Icon(Icons.event, color: green),
            title: Text(x['title'] ?? ''), subtitle: Text('${x['date'] ?? ''}\n${x['description'] ?? ''}')));
        }).toList());
      }));
}

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});
  @override
  State<DonationPage> createState() => _DonationPageState();
}
class _DonationPageState extends State<DonationPage> {
  final name = TextEditingController(), phone = TextEditingController(), purpose = TextEditingController();
  final amount = TextEditingController();
  bool saving = false;
  @override
  void dispose() { name.dispose(); phone.dispose(); purpose.dispose(); amount.dispose(); super.dispose(); }
  Future<void> submit() async {
    final value = double.tryParse(amount.text.trim());
    if (name.text.trim().isEmpty || phone.text.trim().isEmpty || value == null || value <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter name, phone and a valid amount.')));
      return;
    }
    setState(() => saving = true);
    try {
      await FirebaseFirestore.instance.collection('donationRegistrations').add({
        'name': name.text.trim(), 'phone': phone.text.trim(), 'purpose': purpose.text.trim(),
        'amount': value, 'status': 'pending', 'createdAt': FieldValue.serverTimestamp(),
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration submitted. This is not a payment receipt.')));
      name.clear(); phone.clear(); purpose.clear(); amount.clear();
    } catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not submit. Please try again.')));
    } finally { if (mounted) setState(() => saving = false); }
  }
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Sewa & Donation Registration',
    child: ListView(children: [
      const Text('Register a donation or sewa pledge. Payment is not processed in this form.'),
      TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name')),
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
      TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Amount (INR)')),
      TextField(controller: purpose, decoration: const InputDecoration(labelText: 'Purpose / Sewa')),
      const SizedBox(height: 16),
      FilledButton(onPressed: saving ? null : submit,
        child: Text(saving ? 'Submitting...' : 'Submit registration')),
    ]));
}

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Expense Records', child:
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('expenses').orderBy('createdAt', descending: true).limit(100).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return const Text('Expense records are not available.');
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        if (snap.data!.docs.isEmpty) return const Text('No public expense summary has been published.');
        return ListView(children: snap.data!.docs.map((d) {
          final x = d.data();
          return Card(child: ListTile(title: Text(x['category'] ?? 'Expense'),
            subtitle: Text('${x['date'] ?? ''} · ${x['note'] ?? ''}'),
            trailing: Text('₹${x['amount'] ?? 0}')));
        }).toList());
      }));
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Photo Gallery', child:
    StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: FirebaseFirestore.instance.collection('gallery').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return const Text('Could not load gallery.');
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snap.data!.docs;
        if (docs.isEmpty) return const Text('Photos will appear here after the committee uploads them.');
        return GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
          itemCount: docs.length, itemBuilder: (context, i) {
            final x = docs[i].data();
            return Card(clipBehavior: Clip.antiAlias, child: Image.network(
              x['imageUrl'] ?? '', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image))));
          });
      }));
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(title: 'Contact', child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Gurudwara Shri Singh Sabha Bhirdana', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      SizedBox(height: 8), Text('Bhirdana, Haryana, India'),
      SizedBox(height: 8), Text('Please ask the committee to add its verified phone number and address in the app configuration.'),
    ]));
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) => const SimplePage(title: 'About', child: Text(
    'Gurudwara Shri Singh Sabha Bhirdana app connects the sangat with daily Hukamnama, live Kirtan, events, sewa registration and committee updates.')));
}

class SettingsPage extends StatelessWidget {
  final void Function(Locale) onLocale;
  final Locale locale;
  const SettingsPage({super.key, required this.onLocale, required this.locale});
  @override
  Widget build(BuildContext context) => SimplePage(title: 'Settings', child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Choose language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      RadioListTile<Locale>(title: const Text('ਪੰਜਾਬੀ'), value: const Locale('pa'), groupValue: locale, onChanged: (v) { if(v != null) onLocale(v); }),
      RadioListTile<Locale>(title: const Text('हिंदी'), value: const Locale('hi'), groupValue: locale, onChanged: (v) { if(v != null) onLocale(v); }),
      RadioListTile<Locale>(title: const Text('English'), value: const Locale('en'), groupValue: locale, onChanged: (v) { if(v != null) onLocale(v); }),
    ]));
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}
class _AdminPageState extends State<AdminPage> {
  final email = TextEditingController(), password = TextEditingController();
  final expenseCategory = TextEditingController(), expenseAmount = TextEditingController(), expenseNote = TextEditingController();
  final eventTitle = TextEditingController(), eventDate = TextEditingController(), eventDescription = TextEditingController();
  final hukamTitle = TextEditingController(), hukamText = TextEditingController(), hukamMeaning = TextEditingController();
  bool busy = false;
  @override
  void dispose() {
    email.dispose(); password.dispose(); expenseCategory.dispose(); expenseAmount.dispose();
    expenseNote.dispose(); eventTitle.dispose(); eventDate.dispose(); eventDescription.dispose();
    hukamTitle.dispose(); hukamText.dispose(); hukamMeaning.dispose(); super.dispose();
  }
  Future<bool> isAdmin(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('admins').doc(uid).get();
    return doc.exists && doc.data()?['active'] == true;
  }
  Future<void> signIn() async {
    setState(() => busy = true);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(), password: password.text);
      if (!await isAdmin(credential.user!.uid)) {
        await FirebaseAuth.instance.signOut();
        throw Exception('This account is not an authorized admin.');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
    } finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> addExpense() async {
    final amount = double.tryParse(expenseAmount.text.trim());
    if (expenseCategory.text.trim().isEmpty || amount == null || amount <= 0) return;
    await FirebaseFirestore.instance.collection('expenses').add({
      'category': expenseCategory.text.trim(), 'amount': amount, 'note': expenseNote.text.trim(),
      'date': DateTime.now().toIso8601String().substring(0,10),
      'createdAt': FieldValue.serverTimestamp(), 'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });
    expenseCategory.clear(); expenseAmount.clear(); expenseNote.clear();
  }
  Future<void> addEvent() async {
    if (eventTitle.text.trim().isEmpty || eventDate.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('events').add({
      'title': eventTitle.text.trim(), 'date': eventDate.text.trim(),
      'description': eventDescription.text.trim(), 'createdAt': FieldValue.serverTimestamp(),
      'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });
    eventTitle.clear(); eventDate.clear(); eventDescription.clear();
  }
  Future<void> addHukamnama() async {
    if (hukamTitle.text.trim().isEmpty || hukamText.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('hukamnamas').add({
      'title': hukamTitle.text.trim(), 'text': hukamText.text.trim(),
      'meaning': hukamMeaning.text.trim(), 'date': DateTime.now().toIso8601String().substring(0,10),
      'createdAt': FieldValue.serverTimestamp(), 'createdBy': FirebaseAuth.instance.currentUser!.uid,
    });
    hukamTitle.clear(); hukamText.clear(); hukamMeaning.clear();
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return SimplePage(title: 'Admin Login', child: ListView(shrinkWrap: true, children: [
      const Text('Committee members only. Create an admin user in Firebase Authentication and add admins/{uid} with active=true using the Firebase Console.'),
      TextField(controller: email, decoration: const InputDecoration(labelText: 'Admin email')),
      TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
      const SizedBox(height: 12),
      FilledButton(onPressed: busy ? null : signIn, child: Text(busy ? 'Signing in...' : 'Sign in')),
    ]));
    return SimplePage(title: 'Admin Panel', child: ListView(children: [
      Text('Signed in: ${user.email ?? user.uid}'),
      Align(alignment: Alignment.centerLeft, child: TextButton(
        onPressed: () => FirebaseAuth.instance.signOut(), child: const Text('Sign out'))),
      const Divider(),
      const Text('Add Hukamnama', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      TextField(controller: hukamTitle, decoration: const InputDecoration(labelText: 'Title')),
      TextField(controller: hukamText, maxLines: 3, decoration: const InputDecoration(labelText: 'Gurbani text')),
      TextField(controller: hukamMeaning, maxLines: 2, decoration: const InputDecoration(labelText: 'Meaning / translation')),
      FilledButton(onPressed: addHukamnama, child: const Text('Publish Hukamnama')),
      const Divider(),
      const Text('Add Event', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      TextField(controller: eventTitle, decoration: const InputDecoration(labelText: 'Event title')),
      TextField(controller: eventDate, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
      TextField(controller: eventDescription, decoration: const InputDecoration(labelText: 'Description')),
      FilledButton(onPressed: addEvent, child: const Text('Publish event')),
      const Divider(),
      const Text('Record expense', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      TextField(controller: expenseCategory, decoration: const InputDecoration(labelText: 'Category')),
      TextField(controller: expenseAmount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount INR')),
      TextField(controller: expenseNote, decoration: const InputDecoration(labelText: 'Note / bill reference')),
      FilledButton(onPressed: addExpense, child: const Text('Save expense')),
      const Divider(),
      const Text('Donation registrations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance.collection('donationRegistrations').orderBy('createdAt', descending: true).limit(50).snapshots(),
        builder: (context, snap) {
          if (!snap.hasData) return const LinearProgressIndicator();
          return Column(children: snap.data!.docs.map((d) {
            final x = d.data();
            return ListTile(title: Text('${x['name'] ?? ''} · ₹${x['amount'] ?? 0}'),
              subtitle: Text('${x['phone'] ?? ''} · ${x['purpose'] ?? ''} · ${x['status'] ?? 'pending'}'),
              trailing: IconButton(icon: const Icon(Icons.check_circle_outline), tooltip: 'Mark verified',
                onPressed: () => d.reference.update({'status':'verified','verifiedAt':FieldValue.serverTimestamp(),'verifiedBy':user.uid})));
          }).toList());
        }),
    ]));
  }
}
