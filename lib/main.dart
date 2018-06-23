import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_challange_music_player/Songs.dart';
import 'package:flutter_challange_music_player/theme.dart';
import 'package:fluttery/gestures.dart';
import 'package:meta/meta.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: new Text(""),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: const Color(0xFFBBBBBB),
            onPressed: () {},
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              color: const Color(0xFFBBBBBB),
              onPressed: () {},
            ),
          ]),
      body: new Column(
        children: <Widget>[
          //Seek bar
          new Expanded(
            child: RadialSeekBar(),
          ),
          //Visualizer
          Visualizer(),
          //Controls song title and artist name
          BottomControls()
        ],
      ),
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  final double seekPercent;

  RadialSeekBar({this.seekPercent = 0.0});

  @override
  RadialSeekBarState createState() {
    return RadialSeekBarState();
  }
}

class RadialSeekBarState extends State<RadialSeekBar> {
  double _seekPercentage = 0.0;
  double _startDragPercentage;
  double _currentDragPercentage;
  PolarCoord _startDragCoord;

  @override
  void initState() {
    super.initState();
    _seekPercentage = widget.seekPercent;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _seekPercentage = widget.seekPercent;
  }

  _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercentage = _seekPercentage;
  }

  _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    final dragPercent = dragAngle / (2 * pi);
    setState(() =>
        _currentDragPercentage = (_startDragPercentage + dragPercent) % 1.0);
  }

  _onDragStop() {
    _seekPercentage = _currentDragPercentage;
    _currentDragPercentage = null;
    _startDragCoord = null;
    _startDragPercentage = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragEnd: _onDragStop,
      onRadialDragUpdate: _onDragUpdate,
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: RadialProgressbar(
              thumbPosition: _currentDragPercentage ?? _seekPercentage,
              progressPercentage: _currentDragPercentage ?? _seekPercentage,
              innerPadding: const EdgeInsets.all(10.0),
              progressColor: accentColor.withOpacity(0.9),
              trackColor: accentColor.withOpacity(0.3),
              thumbSize: 6.0,
              thumbColor: accentColor,
              child: new ClipOval(
                clipper: CircleClipper(),
                child: Image.network(
                  demoPlaylist.songs[0].albumArtUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RadialDragGestureDetector buildRadialSeekBar() {
    return new RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragEnd: _onDragStop,
      onRadialDragUpdate: _onDragUpdate,
      child: new Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: RadialProgressbar(
              thumbPosition: _currentDragPercentage ?? _seekPercentage,
              progressPercentage: _currentDragPercentage ?? _seekPercentage,
              innerPadding: const EdgeInsets.all(10.0),
              progressColor: accentColor.withOpacity(0.9),
              trackColor: accentColor.withOpacity(0.3),
              thumbSize: 6.0,
              thumbColor: accentColor,
              child: new ClipOval(
                clipper: CircleClipper(),
                child: Image.network(
                  demoPlaylist.songs[0].albumArtUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
        center: new Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true;
}

class BottomControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      color: accentColor,
      child: new Material(
        shadowColor: const Color(0x44000000),
        color: accentColor,
        child: new Padding(
          padding: const EdgeInsets.only(top: 40.0, bottom: 50.00),
          child: Column(
            children: <Widget>[
              new SongInfo(),
              new Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Container()),
                    PreviousButton(),
                    Expanded(child: Container()),
                    PlayPauseButton(),
                    Expanded(child: Container()),
                    NextButton(),
                    Expanded(child: Container()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SongInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "",
        children: [
          TextSpan(
            text: demoPlaylist.songs[0].songTitle.toUpperCase() + "\n",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 4.0,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: demoPlaylist.songs[0].artist.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              letterSpacing: 3.0,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_previous),
      color: Colors.white,
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      iconSize: 35.0,
      onPressed: () {},
    );
  }
}

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: CircleBorder(),
      fillColor: Colors.white,
      splashColor: lightAccentColor,
      highlightColor: lightAccentColor.withOpacity(0.5),
      elevation: 10.0,
      highlightElevation: 5.0,
      onPressed: () {},
      child: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          Icons.play_arrow,
          color: darkAccentColor,
          size: 45.0,
        ),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_next),
      splashColor: lightAccentColor,
      highlightColor: Colors.transparent,
      color: Colors.white,
      iconSize: 35.0,
      onPressed: () {},
    );
  }
}

class Visualizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 125.0,
    );
  }
}

class RadialProgressbar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;

  final double progressWidth;
  final Color progressColor;
  final double progressPercentage;

  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Widget child;

  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;

  RadialProgressbar(
      {this.trackWidth = 3.0,
      this.trackColor = Colors.grey,
      this.progressWidth = 5.0,
      this.progressColor = Colors.grey,
      this.progressPercentage = 40.0,
      this.thumbSize = 10.0,
      this.thumbColor = Colors.grey,
      this.thumbPosition = 0.0,
      this.innerPadding = const EdgeInsets.all(0.0),
      this.outerPadding = const EdgeInsets.all(0.0),
      this.child});

  @override
  State<StatefulWidget> createState() {
    return _RadialProgressBarState();
  }
}

class _RadialProgressBarState extends State<RadialProgressbar> {
  EdgeInsets _insectsForPainter() {
    final outerThickness =
        max(widget.trackWidth, max(widget.progressWidth, widget.thumbSize)) / 2;
    return new EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialSeekBarPainter(
            progressColor: widget.progressColor,
            progressPercentage: widget.progressPercentage,
            progressWidth: widget.progressWidth,
            thumbColor: widget.thumbColor,
            thumbPosition: widget.thumbPosition,
            thumbSize: widget.thumbSize,
            trackColor: widget.trackColor,
            trackWidth: widget.trackWidth),
        child: Padding(
          padding: _insectsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Color trackColor;
  final Paint trackPaint;

  final double progressWidth;
  final Color progressColor;
  final double progressPercentage;
  final Paint progressPaint;

  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  final Paint thumbPaint;

  RadialSeekBarPainter(
      {@required this.trackWidth,
      @required this.trackColor,
      @required this.progressWidth,
      @required this.progressColor,
      @required this.progressPercentage,
      @required this.thumbSize,
      @required this.thumbColor,
      @required this.thumbPosition})
      : trackPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = trackColor
          ..strokeWidth = trackWidth,
        progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..color = progressColor
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = thumbColor;

  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(thumbSize, progressWidth));
    final constrainedSize =
        Size(size.width - outerThickness, size.height - outerThickness);
    //Draw circle
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius =
        min(constrainedSize.height, constrainedSize.width) / 2;
    canvas.drawCircle(center, radius, trackPaint);

    //Draw Progress

    final sweepAngle = 2 * pi * progressPercentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        sweepAngle, false, progressPaint);

    //Draw thumbs

    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
