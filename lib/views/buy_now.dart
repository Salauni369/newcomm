import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyNowPage extends StatelessWidget {
  final String productName;
  final int price;
  final String image;

  const BuyNowPage({
    super.key,
    required this.productName,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Now', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: Colors.grey[100],
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        TextEditingController locationController =
                        TextEditingController();
                        String currentLocation = "Lucknow - 226001";

                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Change Delivery Location",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              Text("Current Address: $currentLocation",
                                  style: const TextStyle(fontSize: 16)),
                              const SizedBox(height: 16),
                              TextField(
                                controller: locationController,
                                decoration: InputDecoration(
                                  labelText: "Enter new address / PIN code",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (locationController.text.isNotEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "Location changed to ${locationController.text}"),
                                            ),
                                          );
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text("Submit"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.location_on, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        "Delivering to Lucknow - 226001",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Icon(Icons.keyboard_arrow_down),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),


              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),


              Text(
                productName,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '₹$price',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 30),

              const Text(
                'Choose Payment Method',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),


              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cash on Delivery selected!')),
                  );
                },
                icon: const Icon(Icons.money),
                label: const Text(
                  'Cash on Delivery',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),


              ElevatedButton.icon(
                onPressed: () async {
                  final upiUrl = Uri.parse(
                      'upi://pay?pa=example@upi&pn=YourMerchantName&mc=1234&tid=TXN12345&tr=123456&tn=Payment%20for%20Order&am=$price&cu=INR');

                  if (await canLaunchUrl(upiUrl)) {
                    await launchUrl(upiUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch UPI app')),
                    );
                  }
                },
                icon: const Icon(Icons.payment),
                label: const Text(
                  'Pay Online',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
