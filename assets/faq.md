## Cashier App FAQ

### What can this assistant help me with?
The chatbot can answer common questions about managing products, barcode scanning, pricing, and stock updates inside the cashier app.

### How do I add a new product?
Open the Add button on the Products page, fill in the product details, and tap Save. Stock starts at the quantity you enter.

### How do I scan items for purchase?
Use the **Purchase** button on the Products page, then scan the barcode of the item the customer wants to buy.

### Does stock update automatically?
Yes. Every successful purchase decreases the stock count automatically. Update stock manually through the Edit option when needed.

### Can I customize currency or branding?
Yes. Edit `lib/const.dart` to change colors, currency, and other constants. Replace assets under `assets/logo` for branding.


### How do I process a refund or return?
Currently, the app handles stock deduction upon purchase. To process a return, navigate to the Products page, select the specific item, and manually use the Edit function to increase the stock quantity by the returned amount.

### Can I apply discounts to a transaction?
Discounts are not applied automatically. You must either edit the product price temporarily before scanning or create a separate "Discount" product with a negative value (if the system allows negative integers) or a manual price override.

### What do I do if a barcode won't scan?
If the camera fails to recognize a barcode due to low light or damage:
- Ensure the camera lens is clean.
- Tap the Manual Input button (if available) to type the barcode number physically.
- Use the search bar to find the product by name.

### Does the app work without an internet connection?
Yes. The Cashier App is designed with an "Offline First" architecture. All product and sales data are stored in a local database. Data syncs to the cloud only if you have configured a remote backend.

### Who do I contact if the app crashes or malfunctions?
For general technical issues, please contact the IT Support Team. Email: support@yourcompany.com. Urgent Line: +1 (555) 010-9999 (Available 9 AM - 5 PM). Ticket System: Visit helpdesk.yourcompany.com to track the status of your request.