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
    DECLARE id INT UNSIGNED;
    DECLARE id_post INT UNSIGNED;
    DECLARE row_not_found TINYINT DEFAULT FALSE;
    
	DECLARE user_cursor CURSOR FOR 
	SELECT user_id 
	FROM users 
	WHERE user_id <> NEW.user_id 
	GROUP BY user_id;
    
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET row_not_found = TRUE;
		
	
	
	INSERT INTO posts
        (user_id, content)
        VALUES
        (NEW.user_id, CONCAT(NEW.first_name, " ", NEW.last_name , " just joined!"));
	
	SET id_post = LAST_INSERT_ID();
	
	
	
	OPEN user_cursor;
   	id_loop : LOOP
    

    	FETCH user_cursor INTO id;
    	IF row_not_found THEN
   	 LEAVE id_loop;
   	 END IF;
    
	
        
   
	
	INSERT INTO notifications
        ( user_id, post_id)
        VALUES 
        
        (id , id_post);
	END LOOP;
    
    	CLOSE user_cursor;
	END;;

	
CREATE EVENT remove_sessions
	ON SCHEDULE EVERY 10 SECOND
    DO 
    BEGIN 
		DELETE FROM sessions WHERE updated_on < DATE_SUB(NOW(), INTERVAL 2 HOUR);
	END;;
      
      
      
      
CREATE PROCEDURE add_post(user_id INT UNSIGNED, content VARCHAR(100))
BEGIN 

DECLARE friend_id INT UNSIGNED;
DECLARE user_friend_id INT UNSIGNED;
DECLARE last_id INT UNSIGNED;
DECLARE row_not_found TINYINT DEFAULT FALSE;




DECLARE friend_cursor CURSOR FOR 
SELECT friend_id FROM friends
WHERE user_id = user_id
GROUP BY user_id;



DECLARE CONTINUE HANDLER FOR NOT FOUND
SET row_not_found = TRUE;
  


INSERT INTO posts
(user_id, content)
VALUES 
(user_id, content);


SET last_id = LAST_INSERT_ID();

OPEN friend_cursor;
   	id_loop : LOOP
    

	FETCH friend_cursor INTO user_friend_id;
	IF row_not_found THEN
	LEAVE id_loop;
	END IF;
    
	INSERT INTO notifications
        ( user_id, post_id)
        VALUES 
        
        (user_friend_id, last_id);
	END LOOP;
    
    	CLOSE friend_cursor;
	END;;

DELIMITER ;







