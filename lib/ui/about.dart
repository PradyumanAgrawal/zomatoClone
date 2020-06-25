import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class About extends StatelessWidget {
  final BuildContext navContext;
  About({this.navContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.deepPurple[800],
      ),
      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Hero(tag: 'about', child: Icon(Icons.info)),
                      Text(
                        " About Us",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  Text(
                      "Porsio is India’s First and Only Application which focuses on providing the latest fashion trends from your nearby retail shops at your fingertips."),
                  Text(
                      "Featured with a bunch of trendy styles for your daily outfit inspiration, we are Priced-friendly too, so we can definitely make you a fashion icon even with limited budgets. "),
                  Text(
                      "With the lowest price and high quality guaranteed, we have items such as apparel, Bags, Shoes, Jewelry as well as Home and Living essentials."),
                  Text(
                      "Porsio , delivers from stores of your choice and brands of your trust. As soon as we receive an order, a member from the Porsio team will pick it up from the store you've ordered and will deliver it to you. Porsio aims at reducing the complexity of standing in a line and wasting your holiday time spending around retail stores, instead you sit back and order, we will deliver what you need within the same day."),
                  Text(
                    "Download the Porsio App and enjoy:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                      "★ Select / Choose a wide range of Products easily from our App. Enjoy Hassle Free Shopping and we have also a wide selection of all the brands you love to Shop."),
                  Text(
                      "★ You’ll receive alerts about exclusive offers, new arrivals and all the latest trends."),
                  Text(
                      "★ Sort products by popularity and price, and refine your search by brand, size and colour."),
                  Text(
                      "★Enjoy low prices and great offers including discounts, bundle pack offerings, Cash-backs on our App."),
                  Text(
                      "★ Add items to your wish list and save them for later."),
                  Text(
                      "★ Share your picks with friends and family via Facebook, Twitter, and Instagram."),
                  Text("★ Same day delivery and return policy. (T & C Apply)"),
                  Text(
                      "★ Choose from different payment options you prefer from Cash on delivery to credit card or PayPal."),
                  Text(
                    "Home Delivery:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                      "Place your order online using the Porsio Online app and get it delivered at your doorstep or office at a convenient time chosen by you. You will be charged a nominal delivery fee as per your location."),
                  Text(
                    "PRESENT IN CITIES",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                      "We currently offer our services in Nanded(selected localities) and Bhubaneswar(selected localities).  In the future, we are looking forward to expanding in more locations."),
                ],
              )),
          Divider(),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Terms of Service",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                Text(
                    "Welcome to Porsio. We provide goods and services to you subject to the notices, terms, and conditions set forth in this agreement (the 'Agreement') .We may from time to time change the terms that govern your use of our Site. We may change, move or delete portions of, or may add to, our Site from time to time. Every time you wish to use our site, please check these Terms and Conditions to ensure you understand the terms that apply at that time. Porsio marketplace private limited reserves the right to change this site and these terms and conditions at any time. You hereby agree and undertake not to host, display, upload, modify, publish, transmit, update or share any information "),
                Text(
                    "To shop with us, you need to be at least 16 years old. Any accessing, browsing, or otherwise using the site indicates your agreement to all the terms and conditions in this Agreement. If you disagree with any part of the Terms then you should discontinue access or use of the Site. Please read this Agreement carefully before proceeding."),
                Text(
                  "By using our app:-",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                    "You agree that in no event shall Porsio, its affiliates, directors, officers, agents, consultants or employees be liable for any purchases made through the Website nor bears any responsibility of any nature whatsoever AND YOU HEREBY WAIVE ANY AND ALL CLAIMS AGAINST PORSIO AND OR ITS REPRESENTATIVE ARISING AS A RESULT OF OR IN RELATION TO THE WEBSITE OR PURCHASES MADE OF PRODUCTS OR SERVICES INCLUDING INTER-ALIA CLAIMS RELATING TO PAYMENT AND DELIVERY OF THE PRODUCTS AND THE LIKE."),
                Text(
                    "You hereby agree and undertake not to host, display, upload, modify, publish, transmit, update or share any information"),
                Text(
                    "1*belongs to another person and to which you do not have any right; 2* Is grossly harmful, harassing, blasphemous, defamatory, obscene, pornographic, paedophilic, libelous, invasive of another’s privacy, hateful, or racially, ethnically objectionable, disparaging, relating or encouraging money laundering or gambling, or otherwise unlawful in any manner whatever; 3* harms minors in any way; 4* infringes any patent, trademark, copyright or another proprietary/intellectual property rights; 5*violates any law for the time being in force; 6* Deceives or misleads the addressee about the origin of such messages communicates any information which is grossly offensive or menacing in nature; 7* Impersonates another person;8* Contains software viruses or any other computer code, files or programs designed to interrupt, destroy or limit the functionality of any computer resource; 9* threatens the unity, integrity, defence, security or sovereignty of India, friendly relations with foreign states, or public order or causes incitement to the commission of any cognizable offense or prevents investigation of any offense or is insulting any other nation; 10* Is misleading or known to be false in any way. "),
                Text(
                    "Any unauthorized use shall automatically terminate the permission or sub-license granted by the Company."),
                Text(
                    "When you use this website and place orders through it, you agree to provide us with your email address, postal address and/or other contact details truthfully and exactly. You also agree that we may use this information to contact you in the context of your order if necessary.We respect your right to privacy."),
                Text(
                  "Return of product",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                    "We are not providing return delivery.For defective products, If a defect or damage is confirmed on the returned products, we will give you a complete refund including the charges you have accrued of delivery and return"),
                Text(
                  "INTELLECTUAL PROPERTY AND OWNERSHIP",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                    "You recognize and agree that all copyright, registered trademarks and other intellectual property rights on all materials or contents provided as part of the website belong to us at all times or to those who grant us the license for their use. You may use said material only to the extent that we or the usage licensers authorize expressly. This does not prevent you from using this website to the extent necessary to copy the information on your order or contact details"),
              ],
            ),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "App Version",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text("1.0.0"),
                Text("Copyrights: Porsio Marketplace private limited"),
                Row(
                  children: [
                    Text("Made with "),
                    Icon(Icons.favorite, color: Colors.grey, size: 15,),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
