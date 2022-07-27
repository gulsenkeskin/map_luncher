import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/locations.dart' as locations;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Office',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Google Office List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var googleOffices;
  @override
  void initState() {
    super.initState();
    fetchList();
    // Future.microtask(() => {fetchList()});
  }

  Future<void> fetchList() async {
    var list = await locations.getGoogleOffices();
    setState(() {
      googleOffices = list.offices;
    });
    // googleOffices =
    //     await locations.getGoogleOffices().then((value) => value.offices);
    print("list $list");
    print("googleOffices $googleOffices");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: OfficeList(
          googleOffices: googleOffices,
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: (){},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class OfficeList extends StatelessWidget {
  const OfficeList({
    Key? key,
    googleOffices,
  })  : _googleOffices = googleOffices,
        super(key: key);

  final dynamic _googleOffices;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 3,
        color: Colors.white,
      ),
      itemCount: _googleOffices.length ?? 0,
      itemBuilder: (ctx, index) {
        return (_googleOffices.length ?? 0) < 1
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Container(
                alignment: Alignment.centerLeft,
                color: Colors.green[50],
                width: MediaQuery.of(ctx).size.width,
                height: MediaQuery.of(ctx).size.height * 0.13,
                child: OfficeListTile(office: _googleOffices[index]),
              );
      },
    );
  }
}

class OfficeListTile extends StatefulWidget {
  const OfficeListTile({
    Key? key,
    required this.office,
  }) : super(key: key);

  final office;

  @override
  _OfficeListTileState createState() => _OfficeListTileState();
}

class _OfficeListTileState extends State<OfficeListTile> {
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        child: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Text(
            widget.office.name ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      subtitle: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          widget.office.address ?? "",
          style: const TextStyle(),
          maxLines: 3,
        ),
      ),
      leading: widget.office.image.isNotEmpty
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.office.image),
              ),
            )
          : Container(),
      trailing: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MapButton(icon: Icons.location_pin,onPressed: (){

            },),
            MapButton(icon: Icons.drive_eta,onPressed: (){},),
            MapButton(icon: Icons.directions_walk,onPressed: (){},),
            MapButton(icon: Icons.directions_transit_filled,onPressed: (){},),
            MapButton(icon: Icons.directions_bike_outlined,onPressed: (){},),
          ],
        ),
      ),
      onTap: () async {},
    );
  }
}

class MapButton extends StatelessWidget {
  const MapButton(
      {Key? key, required IconData icon, required Function onPressed})
      : _icon = icon,
        _onPressed = onPressed,
        super(key: key);

  final IconData _icon;
  final Function _onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () => _onPressed,
        icon: Icon(_icon, size: 18),
        padding: EdgeInsets.all(0.0),
        alignment: Alignment.centerLeft,
        color: Colors.black,
      ),
    );
  }
}
