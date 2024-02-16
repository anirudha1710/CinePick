import 'package:cine_pick/details/movies.dart';
import 'package:cine_pick/details/tvseriesdetail.dart';
import 'package:flutter/material.dart';

class DescriptionCheckUi extends StatefulWidget {
  final  newid;
  final  newtype;
  const DescriptionCheckUi(this.newid, this.newtype, {super.key});

  @override
  State<DescriptionCheckUi> createState() => _DescriptionCheckUiState();
}

class _DescriptionCheckUiState extends State<DescriptionCheckUi> {
  checkType() {
    if (widget.newtype.toString() == 'movie') {
      return MovieDetails(
        id: widget.newid,
      );
    } else if (widget.newtype.toString() == 'tv') {
      return tvSeriesDetail(id: widget.newid);
    } else if (widget.newtype.toString() == 'person') {
      // return personDescriptionUi(widget.id);
    } else {
      return errorUi(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return checkType();
  }
}

Widget errorUi(context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: const Center(
      child: Text('no Such page found'),
    ),
  );
}