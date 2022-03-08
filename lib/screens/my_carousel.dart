import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TopCarousel extends StatefulWidget {
  const TopCarousel({Key key}) : super(key: key);

  @override
  State<TopCarousel> createState() => _TopCarouselState();
}

class _TopCarouselState extends State<TopCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final urlImages = [
    'assets/images/add1.jpeg',
    'assets/images/add2.jpeg',
    'assets/images/add3.jpeg',
    'assets/images/add4.jpeg',
    'assets/images/add5.jpeg',
    'assets/images/add6.jpeg',
    'assets/images/add7.jpeg',
    'assets/images/add8.jpeg',
    'assets/images/add9.jpeg',
    'assets/images/add10.jpeg'
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            //height: 400,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) => setState(() => _current = index),
          ),
          itemCount: urlImages.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = urlImages[index];
            return buildImage(urlImage, index);
          },
        ),
        Container(
          width: size.width,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(10, (index) => null)
                  .asMap()
                  .entries
                  .map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
                  child: Container(
                    width: _current == entry.key ? 20.0 : 8.0,
                    height: 5.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: (_current == entry.key
                                ? Colors.green
                                : Theme.of(context).primaryColor)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            )
          ]),
        )
      ],
    ));
  }

  Widget buildImage(String urlImage, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: Colors.grey,
            child: Image(
              image: AssetImage(
                urlImage,
              ),
              width: double.infinity,
              fit: BoxFit.cover,
            )),
      );
}
