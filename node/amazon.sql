create database amazon;
use amazon;

drop table tags;
drop table orders;
drop table products;
drop table shop;
drop table user;

CREATE TABLE user(
userId INT PRIMARY KEY,
name VARCHAR(40) NOT NULL,
email varchar(40),
mobileNo varchar(15),
location varchar(40),
displayPic VARCHAR(200)
);

INSERT INTO user VALUES(1,'pradyuman','pa12@iitbbs.ac.in','8217299836','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES(2,'shilpi','sa33@iitbbs.ac.in','8217222236','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES(3,'swap','ss92@iitbbs.ac.in','8217299000','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES(4,'kriti','km13@iitbbs.ac.in','821111836','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (5,"Eve","pharetra.nibh@Aliquamnisl.edu","3867018401","66.32471, -173.17652","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (6,"Dane","molestie.sodales.Mauris@interdum.co.uk","6370436131","-8.27631, -88.24877","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (7,"Branden","sed@volutpatnunc.org","9405692625","-76.15378, -8.74558","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (8,"Sloane","eu.tempor.erat@enimNuncut.co.uk","0210658790","71.31952, -100.1512","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (9,"Buckminster","Lorem@amet.ca","1331529924","53.85027, -49.89554","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (10,"Chancellor","commodo.tincidunt.nibh@risusNulla.org","7962485022","69.09324, 119.85562","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (11,"Taylor","sit@aultricies.edu","5796466335","-11.53548, -61.87572","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (12,"Barbara","rutrum.non.hendrerit@malesuadavelvenenatis.org","4193013872","-65.39287, -47.63255","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (13,"Quinlan","hendrerit@ametconsectetuer.org","3306074654","24.88266, 134.34343","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (14,"Brennan","ligula@commodo.net","3588472353","72.01295, -117.8936","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (15,"Oscar","bibendum.ullamcorper.Duis@consectetueripsum.ca","9027100321","71.17184, 132.31079","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (16,"Tatyana","pede.nec.ante@sapienAeneanmassa.ca","3395085569","-27.41693, 144.24863","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (17,"Suki","luctus.felis.purus@anteblandit.co.uk","8135798670","66.06549, 151.92562","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (18,"Vaughan","gravida@Proinnonmassa.com","6736626193","2.37857, 166.16624","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (19,"Martin","lectus.pede@maurisIntegersem.net","2717207632","-38.78496, 38.54288","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");
INSERT INTO `user` (`userId`,`name`,`email`,`mobileNo`,`location`,`displayPic`) VALUES (20,"Jarrod","eu.elit.Nulla@convalliserateget.co.uk","9173572884","-48.34371, -61.09401","https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png");

select * from user;
delete from user;

CREATE TABLE shop(
shopId INT PRIMARY KEY,
address VARCHAR(60) NOT NULL,
ownerId INT,
contact VARCHAR(15),
shopName VARCHAR(40) NOT NULL,
location VARCHAR(40),
type Varchar(30),
FOREIGN KEY (ownerId) REFERENCES user(userId) 
);
INSERT INTO shop VALUES(101,'xyz1,abc1,delhi',1,'8217299811','shop1','delhi','finedine');
INSERT INTO shop VALUES(102,'xyz2,abc2,mumbai',5,'8217299822','shop2','mumbai','bar');
INSERT INTO shop VALUES(103,'xyz3,abc3,bbs',7,'8217299833','shop3','bhubaneswar','asian');
INSERT INTO shop VALUES(104,'xyz4,abc4,delhi',12,'8217299844','shop4','delhi','bakery');
INSERT INTO shop VALUES(105,'xyz5,abc5,mumbai',13,'8217299855','shop5','mumbai','cafe');
INSERT INTO shop VALUES(106,'xyz6,abc6,bbs',17,'8217299866','shop6','bhubaneswar','pizza');
INSERT INTO shop VALUES(107,'xyz7,abc7,bbs',20,'8217299877','shop7','bhubaneswar','foodtruck');
delete from shop;
select * from shop;

CREATE TABLE products(
productId INT PRIMARY KEY,
shopId INT NOT NULL,
pName VARCHAR(30) NOT NULL,
description VARCHAR(200),
price INT NOT NULL,
image VARCHAR(200),
discount INT,
category varchar(30),
FOREIGN KEY (shopId) REFERENCES shop(shopId) 
);
delete from products;
INSERT INTO products VALUES(201,101,'vadapav','dhgfjhhkhiugu','50','https://cdn11.bigcommerce.com/s-kknankib6z/images/stencil/1280x1280/products/16493/32585/vada-pav-2-quantity__06746.1604605596.png?c=2?imbypass=on',15,'street food');
INSERT INTO products VALUES(202,106,'pizza','dhgfjhhkhiugu','350','https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/216054.jpg',20,'italian');
INSERT INTO products VALUES(203,107,'noodles','dhgfjhhkhiugu','80','https://www.loveandoliveoil.com/wp-content/uploads/2015/03/soy-sauce-noodlesH2.jpg',null,'chinese');
INSERT INTO products VALUES(204,105,'sandwich','dhgfjhhkhiugu','60','https://static.toiimg.com/thumb/60057435.cms?width=1200&height=900',null,'health and diet');
INSERT INTO products VALUES(205,103,'momos','dhgfjhhkhiugu','120','https://m.economictimes.com/thumb/msid-70813564,width-1200,height-900,resizemode-4,imgsize-348620/momos.jpg',14,'asian');
INSERT INTO products VALUES(206,103,'lassi','dhgfjhhkhiugu','55','https://upload.wikimedia.org/wikipedia/commons/f/f1/Salt_lassi.jpg',null,'beverages');

CREATE TABLE Address(
userId INT,
addrId INT PRIMARY KEY,
city VARCHAR(20) NOT NULL,
line1 VARCHAR(40) NOT NULL,
line2 varchar(40),
name varchar(40) not null,
phone varchar(40) not null,
state varchar(40) not null,
FOREIGN KEY (userId) REFERENCES user(userId) 
);

insert into Address values ('001','01','xyz1','xyz2', null,'9999999999','xyz3');

CREATE TABLE orders(
productId INT,
addrId INT NOT NULL,
status VARCHAR(20) NOT NULL,
date DATE,
bill INT NOT NULL,
FOREIGN KEY (productId) REFERENCES products(productId),
FOREIGN KEY (addrId) REFERENCES Address(addrId) 
);

INSERT INTO orders VALUES('201','01','on the way',sysdate(),'59');

CREATE TABLE tags(
productID INT,
tags VARCHAR(30),
FOREIGN KEY (productID) REFERENCES products(productId)
);

INSERT INTO tags VALUES('201','abcdef');


DELIMITER $$ 
create PROCEDURE modifyCart(in uId varchar(30),in pId int,in quantity int,out status int)
BEGIN
	declare
	prevqty int;
    status=2;
    insert ignore into cart values (userId,productId,quantity);
    select quantity into prevqty from cart where userId = uId and productId=pId;
    if(quantity=0) Then
		delete from cart where userId = uId and productId=pId;
        status=1
    elseif(quantity!=prevqty)
	  Update cart set quantity=quantity where  userId = uId and productId=pId;
      status=1
    end if;
END $$
DELIMITER ;