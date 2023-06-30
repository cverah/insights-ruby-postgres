CREATE TABLE clients(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  age INTEGER CHECK ( age > 0),
  gender VARCHAR,
  occupation VARCHAR,
  nationality VARCHAR
);

CREATE TABLE restaurants(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  category VARCHAR NOT NULL,
  city VARCHAR NOT NULL,
  address VARCHAR NOT NULL
);

CREATE TABLE dishes(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL
);

CREATE TABLE prices(
  id SERIAL PRIMARY KEY,
  price INTEGER NOT NULL CHECK(price > 0),
  restaurant_id INTEGER NOT NULL REFERENCES restaurants(id),
  dish_id INTEGER NOT NULL REFERENCES dishes(id)
);

CREATE TABLE visits(
  id SERIAL PRIMARY KEY,
  visit_date DATE NOT NULL,
  client_id INTEGER NOT NULL REFERENCES clients(id),
  price_id INTEGER NOT NULL REFERENCES prices(id)
);
