# Fullstack JS (reactjs, expressjs, postgresql)

Simple CRUD app built with ReactJS, ExpressJS, PostgreSQL.

```
Database    : postgresql
Backend     : localhost:8080
Frontend    : localhost:8081
```

# Setup

## Database postgresql
1. create cloudsql
1. create user `people` and save password on cloudsql
1. create database `people`
1. add connection network fromm vm to cloudsql
1. restore db
```
psql -p 5432 -h 34.xxx.xxx.xxx -U people -W people
```

```sql
-- for postgresql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name varchar(30),
  email varchar(30),
  gender varchar(6)
);

INSERT INTO users (name, email, gender) VALUES
('John Doe', 'john@gmail.com', 'Male'),
('Mark Lee', 'mlee@gmail.com', 'Male'),
('Sofia', 'sofia@gmail.com', 'Female'),
('Michelle', 'mangela@gmail.com', 'Female');

exit
```

## Backend

Create .env file. Configure with appropriate value.

```
cd backend
cp .env.example .env
```

Simply install all dependencies then start the app. And you can start with this command. You'll see the server is running on port `8080`
```
npm install
npm start
```

## Frontend

Create .env file. Configure with appropriate value.

```
cd frontend
cp .env.example .env
```

Because this is a React app, you can install all dependencies.
```
npm install
npm start
```

# Credit

All credit goes to [M. Fikri](https://www.youtube.com/watch?v=es9_6RFR7wk&t=3336s) as creator of this app.

App used:

[Frontend](https://github.com/mfikricom/Frontend-React-MySQL)
[Backend](https://github.com/mfikricom/Backend-API-Express-MySQL)
