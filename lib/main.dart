import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp( ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: '커스텀 별 모양 평점 위젯',
      theme: ThemeData(
        primaryColor: Colors.orangeAccent,

      ),

      home: Scaffold(
        backgroundColor: Colors.green,
        body: Center(
          child: RatingBar(
            rating: 4.32,
            ratingCount: 12,

          ),
        ),
      ),
    );

  }
}

//Stack으로 채워져 있는 별 아이콘, 빈 별 아이콘을 겹친 후 필요한 영역만 오려내서 dynamic rating을 표현하는 위젯

class RatingBar extends StatelessWidget {
  final double rating; // 평점
  final double size; // 별표 아이콘 크기
  final int ratingCount; // 총 평가 횟수
  RatingBar({required this.rating, required this.ratingCount, this.size = 18}); // 생성자

  @override
  Widget build(BuildContext context) {
    List<Widget> _starList = []; // 별표 위젯 리스트

    int realNumber = rating.floor(); // 정수 부분
    int partNumber = ((rating - realNumber) * 10).ceil(); // 실수 부분

    for (int i = 0; i < 5; i++) { // 별표 아이콘 생성
      if (i < realNumber) { // 정수 부분에 해당하는 별표 아이콘 생성
        _starList.add(Icon(Icons.star, color: Theme.of(context).primaryColor, size: size));
      } else if (i == realNumber) { // 실수 부분에 해당하는 별표 아이콘 생성
        _starList.add(SizedBox(
          height: size,
          width: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Icon(Icons.star, color: Theme.of(context).primaryColor, size: size), // 채워진 별표 아이콘
              ClipRect(
                clipper: _Clipper(part: partNumber), // 클리핑 (오려내기) 영역
                child: Icon(Icons.star, color: Colors.grey, size: size), // 빈 별표 아이콘
              )
            ],
          ),
        ));
      } else { // 나머지 경우에 해당하는 별표 아이콘 생성
        _starList.add(Icon(Icons.star, color: Colors.grey, size: size));
      }
    }

    // 평가 횟수를 표시하는 텍스트 위젯 추가
    ratingCount != null ? _starList.add(Padding(
        padding: EdgeInsets.only(left:10),
        child: Text('($ratingCount)', style: TextStyle(
            fontSize: size*0.8, color: Theme.of(context).disabledColor)
        )),
    ) : SizedBox();

    // 가로로 배열된 별표 위젯 리스트를 반환
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _starList,
    );
  }
}

class _Clipper extends CustomClipper<Rect> {
  final int part; // 클리핑할 영역의 크기

  _Clipper({required this.part}); // 생성자

  @override
  Rect getClip(Size size) { // 클리핑할 영역 반환
    return Rect.fromLTRB(
      (size.width / 10) * part,
      0.0,
      size.width,
      size.height,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => true; // 클리핑이 필요한 경우 true 반환
}