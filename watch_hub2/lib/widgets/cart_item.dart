// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '/providers/cart_provider.dart';

// class CartItemWidget extends StatelessWidget {
//   final String id;
//   final String watchId;
//   final String title;
//   final int quantity;
//   final double price;
//   final String imageUrl;

//   const CartItemWidget({
//     super.key,
//     required this.id,
//     required this.watchId,
//     required this.title,
//     required this.quantity,
//     required this.price,
//     required this.imageUrl,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: ValueKey(id),
//       background: Container(
//         color: Theme.of(context).colorScheme.error,
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.only(right: 20),
//         margin: const EdgeInsets.symmetric(
//           horizontal: 15,
//           vertical: 4,
//         ),
//         child: const Icon(
//           Icons.delete,
//           color: Colors.white,
//           size: 40,
//         ),
//       ),
//       direction: DismissDirection.endToStart,
//       confirmDismiss: (direction) {
//         return showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             title: const Text('Are you sure?'),
//             content: const Text('Do you want to remove the item from the cart?'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop(false);
//                 },
//                 child: const Text('No'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop(true);
//                 },
//                 child: const Text('Yes'),
//               ),
//             ],
//           ),
//         );
//       },
//       onDismissed: (direction) {
//         Provider.of<CartProvider>(context, listen: false).removeItem(id);
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(
//           horizontal: 15,
//           vertical: 4,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage(imageUrl),
//             ),
//             title: Text(title),
//             subtitle: Text('Total: \$${(price * quantity).toStringAsFixed(2)}'),
//             trailing: Text('$quantity x \$${price.toStringAsFixed(2)}'),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final String watchId;
  final double price;
  final int quantity;
  final String title;
  final String imageUrl;

  const CartItemWidget({
    super.key,
    required this.id,
    required this.watchId,
    required this.price,
    required this.quantity,
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red[900],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: const Text(
              'Remove Item',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Remove $title from your cart?',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.amber),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartProvider>(context, listen: false).removeItem(watchId);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '\$${price.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.amber[300],
              fontSize: 16,
            ),
          ),
          trailing: IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .removeSingleItem(watchId);
                  },
                ),
                Text(
                  'x$quantity',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    Provider.of<CartProvider>(context, listen: false)
                        .addItem(watchId, title, price, imageUrl);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}