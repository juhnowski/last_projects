import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {

  final String image;
  final double size;

  UserImage({this.image, this.size = 60});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Container(
          height: size,
          width: size,
          child: image != null
              ? CachedNetworkImage(
                  errorWidget: (context, url, error) =>
                      Image.asset('assets/images/user.png', fit: BoxFit.cover),
                  placeholder: (context, url) => CircularProgressIndicator(),
                  imageUrl: image,
                  fit: BoxFit.cover,
                )
              : Image.asset('assets/images/user.png', fit: BoxFit.cover)),
    );
  }
}
