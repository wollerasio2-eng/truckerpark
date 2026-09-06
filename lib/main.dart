import 'package:flutter/material.dart';

void main() => runApp(const TruckerApp());

class TruckerApp extends StatefulWidget {
  const TruckerApp({super.key});
  @override
  State<TruckerApp> createState() => _TruckerAppState();
}

class _TruckerAppState extends State<TruckerApp> {
  bool dark = true;
  int view = 0;
  String filter = 'Alle';
  bool play = false;
  String audio = 'Spotify';
  Map<String, dynamic>? selected;

  final List<Map<String, dynamic>> spots = [
    {
      'name': 'Industriegebiet Hansalinie',
      'hwy': 'A1 - Ausfahrt 64',
      'type': 'Gewerbegebiet',
      'status': 'green',
      'ago': 'vor 4 Min.',
      'dog': true,
      'notes': 'Große Wendeschleife. Ruhig. Breiter Grünstreifen für Hunde. Bäcker 300m.',
      'x': 0.35,
      'y': 0.40,
    },
    {
      'name': 'Autohof Sittensen',
      'hwy': 'A1 - Ausfahrt 47',
      'type': 'Autohof',
      'status': 'red',
      'ago': 'vor 12 Min.',
      'dog': false,
      'notes': 'Komplett dicht! Stehen schon in der Ausfahrt.',
      'x': 0.60,
      'y': 0.28,
    },
    {
      'name': 'Gewerbepark West',
      'hwy': 'A2 - Ausfahrt 28',
      'type': 'Gewerbegebiet',
      'status': 'yellow',
      'ago': 'vor 18 Min.',
      'dog': true,
      'notes': 'Noch 2 Lücken frei. Kein Parkverbot. Feldweg für Hunde vorhanden.',
      'x': 0.48,
      'y': 0.65,
    },
  ];

  Color getCol(String s) {
    if (s == 'green') return Colors.greenAccent;
    if (s == 'yellow') return Colors.amber;
    return Colors.redAccent;
  }

  void _addSpot() {
    final nCtrl = TextEditingController();
    final hCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    String t = 'Gewerbegebiet';
    String st = 'green';
    bool d = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF222222),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (c, setM) => Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Live-Meldung senden', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 10),
                TextField(controller: nCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Name / Straße', filled: true, fillColor: Color(0xFF333333))),
                const SizedBox(height: 8),
                TextField(controller: hCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Autobahn / Abfahrt', filled: true, fillColor: Color(0xFF333333))),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ChoiceChip(label: const Text('Gewerbegebiet'), selected: t == 'Gewerbegebiet', selectedColor: Colors.orange, onSelected: (v) => setM(() => t = 'Gewerbegebiet')),
                    const SizedBox(width: 8),
                    ChoiceChip(label: const Text('Autohof'), selected: t == 'Autohof', selectedColor: Colors.orange, onSelected: (v) => setM(() => t = 'Autohof')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(label: const Text('🟢 Frei'), selected: st == 'green', selectedColor: Colors.green, onSelected: (v) => setM(() => st = 'green')),
                    const SizedBox(width: 6),
                    ChoiceChip(label: const Text('🟡 Eng'), selected: st == 'yellow', selectedColor: Colors.amber, onSelected: (v) => setM(() => st = 'yellow')),
                    const SizedBox(width: 6),
                    ChoiceChip(label: const Text('🔴 Voll'), selected: st == 'red', selectedColor: Colors.redAccent, onSelected: (v) => setM(() => st = 'red')),
                  ],
                ),
                SwitchListTile(title: const Text('🐶 Gassi / Hund OK?', style: TextStyle(color: Colors.white, fontSize: 14)), value: d, activeColor: Colors.orange, onChanged: (v) => setM(() => d = v)),
                TextField(controller: noteCtrl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Hinweise (z.B. Wendeschleife)', filled: true, fillColor: Color(0xFF333333))),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
                    onPressed: () {
                      if (nCtrl.text.isNotEmpty) {
                        setState(() {
                          spots.insert(0, {
                            'name': nCtrl.text,
                            'hwy': hCtrl.text.isEmpty ? 'Unbekannt' : hCtrl.text,
                            'type': t,
                            'status': st,
                            'ago': 'gerade eben',
                            'dog': d,
                            'notes': noteCtrl.text.isEmpty ? 'Keine Notiz' : noteCtrl.text,
                            'x': 0.5,
                            'y': 0.5,
                          });
                        });
                        Navigator.pop(ctx);
                      }
                    },
                    child: const Text('Live absenden', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> list = spots;
    if (filter == 'Gewerbegebiet' || filter == 'Autohof') {
      list = spots.where((s) => s['type'] == filter).toList();
    } else if (filter == '🐶 Mit Hund') {
      list = spots.where((s) => s['dog'] == true).toList();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: dark ? const Color(0xFF141414) : const Color(0xFFF4F6F9),
        appBar: AppBar(
          backgroundColor: dark ? const Color(0xFF1B1B1B) : Colors.white,
          title: Row(
            children: [
              const Icon(Icons.local_shipping, color: Colors.orange, size: 22),
              const SizedBox(width: 8),
              Text('TruckerPark Live', style: TextStyle(color: dark ? Colors.white : Colors.black87, fontWeight: FontWeight.bold, fontSize: 17)),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(dark ? Icons.wb_sunny : Icons.nightlight_round, color: dark ? Colors.amber : Colors.black87),
              onPressed: () => setState(() => dark = !dark),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: dark ? const Color(0xFF222222) : Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['Alle', 'Gewerbegebiet', 'Autohof', '🐶 Mit Hund'].map((f) {
                          final sel = filter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: ChoiceChip(
                              label: Text(f, style: TextStyle(color: sel ? Colors.black : Colors.white, fontSize: 11)),
                              selected: sel,
                              selectedColor: Colors.orange,
                              backgroundColor: const Color(0xFF333333),
                              onSelected: (v) => setState(() => filter = f),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(view == 0 ? Icons.list : Icons.map, color: Colors.orange),
                    onPressed: () => setState(() => view = view == 0 ? 1 : 0),
                  )
                ],
              ),
            ),
            Expanded(
              child: view == 0 ? _mapView(list) : _listView(list),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: dark ? const Color(0xFF1B1B1B) : Colors.white,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: audio == 'Spotify' ? const Color(0xFF1DB954) : Colors.orange[800],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(audio == 'Spotify' ? Icons.music_note : Icons.radio, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(audio, style: TextStyle(color: audio == 'Spotify' ? const Color(0xFF1DB954) : Colors.orange[800], fontWeight: FontWeight.bold, fontSize: 11)),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => setState(() => audio = audio == 'Spotify' ? 'Radio BOB!' : 'Spotify'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(3)),
                                child: Text(audio == 'Spotify' ? 'Zu BOB!' : 'Zu Spotify', style: const TextStyle(fontSize: 9, color: Colors.white70)),
                              ),
                            )
                          ],
                        ),
                        Text(audio == 'Spotify' ? 'Highway to Hell - AC/DC' : 'Rock Livestream', style: TextStyle(color: dark ? Colors.white : Colors.black87, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(play ? Icons.pause_circle_filled : Icons.play_circle_filled, color: audio == 'Spotify' ? const Color(0xFF1DB954) : Colors.orange[800], size: 30),
                    onPressed: () => setState(() => play = !play),
                  )
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 55),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.orange[800],
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            label: const Text('Platz melden', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onPressed: _addSpot,
          ),
        ),
      ),
    );
  }

  Widget _mapView(List<Map<String, dynamic>> list) {
    return LayoutBuilder(builder: (ctx, box) {
      final w = box.maxWidth;
      final h = box.maxHeight;

      return Stack(
        children: [
          Container(
            color: dark ? const Color(0xFF151A21) : const Color(0xFFE5E9EC),
            child: Center(
              child: Text('AUTOBOHN-RADAR (A1 / A2 / A7)', style: TextStyle(color: dark ? Colors.white12 : Colors.black12, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          for (final sp in list)
            Positioned(
              left: (sp['x'] as double) * w - 18,
              top: (sp['y'] as double) * h - 20,
              child: GestureDetector(
                onTap: () => setState(() => selected = sp),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: getCol(sp['status']), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)]),
                      child: Icon(sp['type'] == 'Autohof' ? Icons.local_gas_station : Icons.local_shipping, size: 16, color: Colors.black),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(3)),
                      child: Text(sp['name'].toString().split(' ').first, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ),
          if (selected != null)
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Card(
                color: dark ? const Color(0xFF222222) : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: getCol(selected!['status']), width: 2)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selected!['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black87)),
                          InkWell(onTap: () => setState(() => selected = null), child: const Icon(Icons.close, size: 18))
                        ],
                      ),
                      Text('${selected!['hwy']} • ${selected!['status'].toString().toUpperCase()}', style: TextStyle(color: getCol(selected!['status']), fontSize: 11, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(selected!['notes'], style: TextStyle(color: dark ? Colors.white70 : Colors.black87, fontSize: 11)),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(selected!['dog'] ? '🐶 Gassi OK' : 'Kein Gassi', style: TextStyle(color: selected!['dog'] ? Colors.greenAccent : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], visualDensity: VisualDensity.compact),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starte Google Maps nach ${selected!['name']}...')));
                            },
                            child: const Text('Anfahren', style: TextStyle(color: Colors.white, fontSize: 11)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
        ],
      );
    });
  }

  Widget _listView(List<Map<String, dynamic>> list) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 70),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final sp = list[i];
        final col = getCol(sp['status']);
        return Card(
          color: dark ? const Color(0xFF1E1E1E) : Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: col, width: 1.5)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sp['name'], style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: dark ? Colors.white : Colors.black87)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: col.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: col)),
                      child: Text(sp['status'].toString().toUpperCase(), style: TextStyle(color: col, fontWeight: FontWeight.bold, fontSize: 10)),
                    )
                  ],
                ),
                Text('${sp['hwy']} • ${sp['type']}', style: TextStyle(color: Colors.orange[400], fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(sp['notes'], style: TextStyle(color: dark ? Colors.white70 : Colors.black87, fontSize: 11)),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(sp['ago'], style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange[800], visualDensity: VisualDensity.compact),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Starte Maps nach ${sp['name']}...')));
                      },
                      child: const Text('Anfahren', style: TextStyle(color: Colors.white, fontSize: 11)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
