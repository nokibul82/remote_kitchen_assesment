import 'package:flutter/material.dart';

import '../../models/post_model.dart';

class PostItemWidget extends StatelessWidget {
  final PostModel post;
  const PostItemWidget({super.key, required this.post});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(post.title,style: Theme.of(context).textTheme.titleMedium,),
      subtitle: Text(post.body,style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis,),
    );
  }
}
