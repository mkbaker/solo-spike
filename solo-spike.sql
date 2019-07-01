--create table commands
CREATE TABLE "user" (
	"id" SERIAL PRIMARY KEY,
	"firstname" VARCHAR(250),
	"lastname" VARCHAR(250),
	"email" VARCHAR(1000),
	"phone" VARCHAR(10),
	"username" VARCHAR (100),
	"password" VARCHAR (100),
	"is_admin" BOOLEAN DEFAULT 'f',
	"admin_id" INT,
	FOREIGN KEY (admin_id) REFERENCES "user"(id)
	);
	
CREATE TABLE "auction" (
	"id" SERIAL PRIMARY KEY,
	"auction_name" VARCHAR,
	"auction_owner" INT REFERENCES "user"(id)
	"start_date" NOT NULL DEFAULT CURRENT_DATE
	"end_date" NOT NULL DEFAULT CURRENT_DATE
	"bio" VARCHAR (2000)
	"photo_url" VARCHAR
	);

CREATE TABLE "item" (
	"id" SERIAL PRIMARY KEY,
	"name" VARCHAR (100),
	"description" VARCHAR (2000),
	"current bid" INT,
	"photo" VARCHAR,
	"belongs_to" INTEGER REFERENCES auction(id)
	);

CREATE TABLE "user_auction" (
	"id" SERIAL PRIMARY KEY,
	"user_id" INT REFERENCES "user"(id),
	"access_auction" INT REFERENCES auction(id)
	);
	
CREATE TABLE "user_bid" (
	"id" SERIAL PRIMARY KEY,
	"user_id" INT REFERENCES "user"(id),
	"item_id" INT REFERENCES "item"(id),
	"bid" INT);
	
CREATE TABLE "contact" (
	"relation_id" SERIAL PRIMARY KEY,
	"user1_id" INT REFERENCES "user"(id) ON DELETE CASCADE,
	"user2_id" INT REFERENCES "user"(id) ON DELETE CASCADE,
	CHECK ("user1_id" != "user2_id")
	);

	
DROP TABLE "user";
DROP TABLE "contact";
DROP TABLE "auction";
DROP TABLE "item" CASCADE;
DROP TABLE "user_bid";
DROP TABLE "user_auction";
	

--initializing data
INSERT INTO "user" ("firstname","lastname","email","phone","username","password","is_admin","admin_id")
VALUES (
'Kellen',
'B',
'kellen@example.com',
'1234567890',
'kellen',
'1234',
't',
'1');

INSERT INTO "user" ("firstname","lastname","email","phone","username","password","is_admin","admin_id")
VALUES (
'Charles',
'Mongomery',
'chuck@example.com',
'8374638475',
'chuck',
'1234',
't',
'4');

INSERT INTO "user" ("firstname","lastname","email","phone","username","password","admin_id")
VALUES (
'Mark',
'Zuckerberg',
'mark@example.com',
'4847564789',
'mark',
'1234',
'4');

INSERT INTO "auction" ("auction_name","auction_owner")
VALUES ('John Doe','1');

INSERT INTO "item" ("name","description","current bid","photo","belongs_to")
VALUES (
'Plane Ticket',
'One plane ticket, worth up to $800',
'0',
'https://image.shutterstock.com/z/stock-photo-plane-ticket-airline-boarding-pass-template-airport-and-plane-pass-document-1394938604.jpg'
,1);

INSERT INTO "auction" ("auction_name","auction_owner")
VALUES (
'Spongebob Squarepants',
'4');

INSERT INTO "user_auction" ("user_id","access_auction")
VALUES ('1','1'),
('2','1'),
('3','1'),
('4','2'),
('5','2');
	
--/////////////BELOW HERE ARE SOME COMMANDS WE WILL NEED TO UTILIZE THE DATABASE.////////////////--

--get all items from an auction
SELECT * 
FROM "item"
WHERE "belongs_to"=1;

--view all users in an auction
SELECT "username","auction_name", "auction"."id"
FROM "user"
JOIN "user_auction" ON "user"."id"="user_auction"."user_id"
JOIN "auction" ON "user_auction"."access_auction"="auction"."id"
WHERE "auction"."id"='1';

--create contact relationship
INSERT INTO "contact" ("user1_id","user2_id")
VALUES (1,2);

--view all users in admin's contact list
SELECT *
FROM "user"
WHERE "admin_id"=1;
	
--add a new user
INSERT INTO "user" ("firstname","lastname","email","phone","username","password","admin_id")
VALUES (
'Jane',
'Ejemplo',
'jane@example.com',
'4434434443',
'jane',
'1234',
'1');
	
--grant admin status


--display auctions owned by an admin (admin home page)
SELECT * 
FROM auction
WHERE "auction_owner" = '4';

--create new auction (admin home page)
INSERT INTO "auction" ("auction_name","auction_owner", "start_date","end_date")
VALUES (
'Eugene Krabs',
'1',
'2019-07-20',
'2019-07-31');

--add user access to auction (invite user -- admin home page)
INSERT INTO "user_auction" ("user_id","access_auction")
VALUES (
'2',
'1');

--add item to auction
INSERT INTO "item" ("name","description","current bid","photo","belongs_to")
VALUES (
'Pumpkin Pie',
'Homemade and delicious!',
'20',
'https://image.shutterstock.com/z/stock-photo-sweet-homemade-thanksgiving-pumpkin-pie-ready-to-eat-1185116455.jpg',
2);

--delete an auction
DELETE FROM "auction" 
WHERE "id" = '1';

--delete item 
DELETE FROM "item" 
WHERE "id"='2';

--edit item name
UPDATE  "item" 
SET "name" = 'Airplane ticket'
WHERE "id" = 3;

--edit item description
UPDATE "item"
SET "description" = 'Worth up to $800'
WHERE "id" = '3';

--invite users to auction 
INSERT INTO "user_auction" ("user_id","access_auction") 
VALUES ('4','3');

--add a bid to an item
SELECT * FROM "user_bid";
INSERT INTO "user_bid" ("user_id","item_id","bid")
VALUES (
	'2',
	'3',
	'50');

--delete account 


--display an item's name and highest bid, the name and email of the bidder
SELECT "item"."name", "user_bid"."bid", "user"."username", "user"."email"
FROM "item"
JOIN "user_bid" ON "item"."id"="user_bid"."item_id"
JOIN "user" ON "user_bid"."user_id"="user"."id"
WHERE "belongs_to"='2'
ORDER BY "bid" DESC 
LIMIT 1;

--view a user's auctions
SELECT "user"."id","username", "access_auction", "auction"."auction_name"
FROM "user"
JOIN "user_auction" ON "user"."id"="user_auction"."user_id"
JOIN "auction" ON "user_auction"."access_auction"="auction"."id"
WHERE "user"."id"='4';

--display all bids by a user
SELECT "user"."id","username","bid","item"."name"
FROM "user"
JOIN "user_bid" ON "user"."id"="user_bid"."user_id"
JOIN "item" ON "user_bid"."item_id"="item"."id"
WHERE "user"."id"='2';








