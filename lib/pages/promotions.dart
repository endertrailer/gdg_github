import 'package:flutter/material.dart';
import 'package:promotional/firebase/firestore_methods.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PromotionalPage extends StatefulWidget {
  const PromotionalPage({super.key});

  @override
  State<PromotionalPage> createState() => _PromotionalPageState();
}

class _PromotionalPageState extends State<PromotionalPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> _items = [];
  bool loaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.pinkAccent,
      Colors.orange,
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[_currentPage % 5],
        centerTitle: true,
        title: const Text(
          'GDG discount Fiesta',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirestoreMethods().fetchItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text("No items available"));
          }

          return promotionBody(
            items,
            size,
            colors,
            context,
            // onPageChanged: (i) => setState(() => _currentPage = i),
          );
        },
      ),

      // promotionBody(size, colors, context),
      // : Center(child: CircularProgressIndicator()),
    );
  }

  Padding promotionBody(
    _items,
    Size size,
    List<dynamic> colors,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: size.height * 0.35,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      _items[index]["image"],
                      fit: BoxFit.fill,
                      width: double.infinity,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          SmoothPageIndicator(
            controller: _pageController,
            count: _items.length,
            effect: ExpandingDotsEffect(
              activeDotColor: colors[_currentPage % 5],
              dotHeight: 8,
              dotWidth: 8,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            _items[_currentPage]["name"],
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            _items[_currentPage]["description"],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹${_items[_currentPage]["price"]}",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "₹${_items[_currentPage]["discounted"]}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors[_currentPage % 5],
                ),
              ),
            ],
          ),

          // const Spacer(),
          SizedBox(height: 40),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors[_currentPage % 5],
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              FirestoreMethods().saveUserData(_items);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added ${_items[_currentPage]["name"]} to cart!",
                  ),
                ),
              );
            },
            child: const Text(
              "Add to Cart",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
