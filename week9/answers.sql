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
  -- I added thr name of the contrain frienduser because it keep giving me and erro arbout repiting a constrain but this constraint refers to the user table      
	CONSTRAINT friends_fk_friendusers
		FOREIGN KEY (friend_id)
		REFERENCES users(user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);


CREATE TABLE posts (
	post_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	created_on TIMESTAMP NOT NULL DEFAULT NOW(),
	updated_on TIMESTAMP NOT NULL DEFAULT NOW() ON UPDATE NOW(),
    content VARCHAR(100) NOT NULL,
	
	CONSTRAINT posts_fk_users
		FOREIGN KEY (user_id)
		REFERENCES users (user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);


CREATE TABLE notifications (
	notification_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	user_id INT UNSIGNED NOT NULL,
	post_id INT UNSIGNED NOT NULL,
	
	CONSTRAINT notifications_fk_users
		FOREIGN KEY (user_id)
		REFERENCES users(user_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE,
        
	CONSTRAINT notifications_fk_posts
		FOREIGN KEY (post_id)
		REFERENCES posts(post_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);


CREATE OR REPLACE VIEW notification_posts AS
	SELECT n.user_id, u.first_name, u.last_name, p.post_id, p.content
	FROM users u
	LEFT OUTER JOIN posts p
	ON u.user_id = p.user_id
	LEFT OUTER JOIN notifications n
   	ON p.post_id = n.post_id;
    

DELIMITER ;;
-- When a new user is added, create a notification for everyone that states "{first_name} {last_name} just joined!" (for example: "Jeromy Streets just joined!").``

CREATE TRIGGER insert_post
	AFTER INSERT ON users
    FOR EACH ROW
	BEGIN 
	INSERT INTO posts
        (user_id, content)
        VALUES
        (NEW.user_id, CONCAT(NEW.first_name, " ", NEW.last_name , " just joined!"));
        
	INSERT INTO notifications
        ( user_id, post_id)
        VALUES 
        ((SELECT user_id FROM users WHERE user_id <> LAST_INSERT_ID()) , LAST_INSERT_ID());
	END;;
       
	

       

DELIMITER ;







