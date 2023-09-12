import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/Comments.dart';
import '../models/Product.dart';

part 'comment.g.dart';

@RestApi(baseUrl: "https://saltech.space/api/product/cafebazaar")
abstract class CommentsApi {
  factory CommentsApi(Dio dio, {String baseUrl}) = _CommentsApi;

  @POST("/comments/query")
  Future<Comments> getComments(
      @Header("Developer-Id") String apiToken, @Body() Product product);
}
