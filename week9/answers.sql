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


CREATE TABLE sessions (
	session_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	created_on TIMESTAMP NOT NULL DEFAULT NOW(),
	updated_on TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
	
	CONSTRAINT sessions_fk_users
		FOREIGN KEY (user_id)
		REFERENCES users (user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);



CREATE TABLE friends (
	user_friend_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	friend_id INT UNSIGNED NOT NULL,
	
	CONSTRAINT friends_fk_users
		FOREIGN KEY (user_id)
		REFERENCES users(user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE,
        
	CONSTRAINT friends_fk_friendusers
		FOREIGN KEY (friend_id)
		REFERENCES users(user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);
