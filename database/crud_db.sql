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
