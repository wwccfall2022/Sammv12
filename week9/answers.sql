-- Create your tables, views, functions and procedures here!
CREATE SCHEMA social;
USE social;

CREATE TABLE users (
	user_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL ,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL,
    created_on TIMESTAMP NOT NULL DEFAULT NOW()
);


