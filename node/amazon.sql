create database amazon;
use amazon;

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

INSERT INTO user VALUES('001','pradyuman','pa12@iitbbs.ac.in','8217299836','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES('002','shilpi','sa33@iitbbs.ac.in','8217222236','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES('003','swap','ss92@iitbbs.ac.in','8217299000','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');
INSERT INTO user VALUES('004','kriti','km13@iitbbs.ac.in','821111836','chhattisgarh','https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png');

select * from user;

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

INSERT INTO shop VALUES('101','xyz,abc,delhi','001','8217299836','btw','delhi','veg');

CREATE TABLE products(
productId INT PRIMARY KEY,
shopId INT NOT NULL,
pName VARCHAR(30) NOT NULL,
description VARCHAR(200),
price INT NOT NULL,
image VARCHAR(200),
FOREIGN KEY (shopId) REFERENCES shop(shopId) 
);
delete from products;
INSERT INTO products VALUES('201','101','vadapav','dhgfjhhkhiugu','50','https://cdn11.bigcommerce.com/s-kknankib6z/images/stencil/1280x1280/products/16493/32585/vada-pav-2-quantity__06746.1604605596.png?c=2?imbypass=on');

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
FOREIGN KEY (addrId) REFERENCES address(addrId) 
);

INSERT INTO orders VALUES('201','01','on the way',sysdate(),'59');

CREATE TABLE tags(
productID INT,
tags VARCHAR(30),
FOREIGN KEY (productID) REFERENCES products(productId)
);

INSERT INTO tags VALUES('201','abcdef');