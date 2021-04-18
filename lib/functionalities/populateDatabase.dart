class PopulateDatabase{
  static final DBProvider db;
  PopulateDatabase({this.db});
  populateDB() async
  {
     await db.execute("""
            CREATE TABLE user(
            userId TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT,
            mobileNo TEXT,
            location TEXT,
            displayPic TEXT
          )"""
          );
        await db.execute("""
            CREATE TABLE shop(
            shopId TEXT PRIMARY KEY,
            address TEXT NOT NULL,
            ownerId TEXT,
            contact TEXT,
            shopName TEXT NOT NULL,
            location TEXT,
            type TEXT,
            FOREIGN KEY (ownerId)
            REFERENCES user(userId) 
            )"""
          );
        await db.execute("""
            CREATE TABLE products(
            productId TEXT PRIMARY KEY,
            shopId TEXT NOT NULL,
            pName TEXT NOT NULL,
            description TEXT,
            price TEXT NOT NULL,
            image TEXT,
            FOREIGN KEY (shopId)
            REFERENCES shop(shopId) 
            )"""
          );
  }
}