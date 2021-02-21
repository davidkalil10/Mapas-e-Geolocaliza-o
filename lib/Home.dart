import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-23.5953146, -46.6825648),
      zoom: 16,
      tilt: 0, //inclincação
      bearing: 0 // rotação para a esquerda <-
      );
  Set<Marker> _marcadores = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController) {
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_posicaoCamera));
  }

  _carregarMarcadores() {
    /*
    Set<Marker> marcadoresLocal = {};
    Marker marcadorShopping = Marker(
        markerId: MarkerId("marcador-shopping"),
        position: LatLng(-23.5955697, -46.686782),
        infoWindow: InfoWindow(title: "Shopping Vila Olímpia"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueMagenta
      ),
      //rotation: 45,
      onTap: (){
          print("Shopping clicado");
      }
    );

    Marker marcadorReebok = Marker(
        markerId: MarkerId("marcador-reebok"),
        position: LatLng(-23.5958712, -46.68578),
        infoWindow: InfoWindow(title: "Reebok Sports Club"),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen
        ),
        onTap: (){
          print("Treinei");
        });
    marcadoresLocal.add(marcadorShopping);
    marcadoresLocal.add(marcadorReebok);

    setState(() {
      _marcadores = marcadoresLocal;
    });

    */

    /*
    Set<Polygon> listaPolygons = {};
    Polygon polygon1 = Polygon(
        polygonId: PolygonId("Polygon 1"),
        fillColor: Colors.green,
        strokeColor: Colors.red,
        strokeWidth: 10,
      points:[
        LatLng(-23.595097020502962, -46.683528645212355),
        LatLng(-23.596027389069185, -46.68689567624054),
        LatLng(-23.595603424464983, -46.68809084374292),
        LatLng(-23.59541499531215, -46.68800731053039),
        LatLng(-23.594237306974485, -46.68361860405662),
        LatLng(-23.595085243643375, -46.68349009142195),
      ],
      consumeTapEvents: true,
      onTap: (){
          print("cliquei aqui");
      },
      zIndex: 0,
    );
    Polygon polygon2 = Polygon(
        polygonId: PolygonId("Polygon 2"),
        fillColor: Colors.purple,
        strokeColor: Colors.orange,
        strokeWidth: 10,
        points:[
          LatLng(-23.595097020502962, -46.683528645212355),
          LatLng(-23.596027389069185, -46.68689567624054),
          LatLng(-23.595603424464983, -46.68809084374292),
          LatLng(-23.59541499531215, -46.68800731053039),

        ],
        consumeTapEvents: true,
        onTap: (){
          print("cliquei aqui");
        },
      zIndex: 1
    );

    listaPolygons.add(polygon1);
    listaPolygons.add(polygon2);

    setState(() {
      _polygons = listaPolygons;
    });
    */

    Set<Polyline> listaPolylines = {};
    Polyline polyline = Polyline(
        polylineId: PolylineId("polyline"),
        color: Colors.red,
        width: 20,
        startCap: Cap.roundCap,
        jointType: JointType.mitered,
        points: [
          LatLng(-23.595097020502962, -46.683528645212355),
          LatLng(-23.596027389069185, -46.68689567624054),
          LatLng(-23.595603424464983, -46.68809084374292),
          LatLng(-23.59541499531215, -46.68800731053039),
          LatLng(-23.594237306974485, -46.68361860405662),
          LatLng(-23.595085243643375, -46.68349009142195),
        ],
        consumeTapEvents: true,
        onTap: () {
          print("iha");
        });

    listaPolylines.add(polyline);
    setState(() {
      _polylines = listaPolylines;
    });
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    //print("localização atual: " + position.toString());

    setState(() {
      _posicaoCamera = CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
      _movimentarCamera();
    });

  }

  _adicionarListenerLocalizacao() {
    //var geolocator = Geolocator();

    //var locationOptions = LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 10);
     Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best, distanceFilter: 10)
        .listen((Position position) {
      print("localização atual: " + position.toString());

      Marker marcadorUsuario = Marker(
          markerId: MarkerId("marcador-usuario"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "Meu Local"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen
          ),
          onTap: (){
            print("Meu Local clicado!");
          });

      setState(() {
        _marcadores.add(marcadorUsuario);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 17);
        _movimentarCamera();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // _carregarMarcadores();
    _recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mapas e Geolocalização"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: _movimentarCamera,
        child: Icon(Icons.done),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          //-23.5953146,-46.6825648
          initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: _marcadores,
          //polygons: _polygons,
          //polylines: _polylines,
        ),
      ),
    );
  }
}
