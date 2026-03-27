import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.local_pizza, size: 64, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Jesse's Pizza",
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Our Story',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jesse brought his family to Las Vegas in 1946. In 1950 he and his '
              'wife Edna bought the Mina Mansion and turned it into a restaurant. '
              "Nevada's former state capitol was in a city called Mina. When the "
              "capitol was moved to Carson City, the governor's mansion was "
              'relocated to Las Vegas. It was there that Jesse, Edna, and their '
              'son Jack lived upstairs, while downstairs they entertained and fed '
              "Las Vegas prominent dignitaries and Strip performers.",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 16),
            const Text(
              "Having been raised in restaurants and casino kitchens, Jesse's son "
              'Jack learned from a heritage of outstanding cooks. Now Jack and '
              'his two sons bring their age-old family tradition to your '
              'neighborhood pizza shop. You and your family are welcome to enjoy '
              'the original recipes and cooking techniques that are the product '
              "of Jesse's legacy.",
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Our Food',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Our menu is filled with items made from scratch, not just our '
              'pizza. Our pizza sauce is a secret recipe, but we are willing to '
              'reveal to you, our customers, the one secret ingredient that makes '
              'our sauce so good... time. We chop, we mix, we stir... for hours. '
              'This is no canned pizza sauce like you will get with almost every '
              'other pizza out there. This pizza is the real thing.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Built with Flutter',
                style: TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
