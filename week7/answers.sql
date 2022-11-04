-- Create your tables, views, functions and procedures here!
CREATE SCHEMA destruction;
USE destruction;

CREATE TABLE players (
	player_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL
);

CREATE TABLE characters (
	character_id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	player_id INT UNSIGNED NOT NULL,
    	name VARCHAR(30) NOT NULL,
    	level INT UNSIGNED DEFAULT 0,
	
    	CONSTRAINT characters_fk_players
		FOREIGN KEY (player_id)
		REFERENCES players (player_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);

CREATE TABLE winners (
	character_id INT UNSIGNED NOT NULL PRIMARY KEY,
	name VARCHAR(30) NOT NULL,
	
    	CONSTRAINT winners_fk_characters
		FOREIGN KEY (character_id)
		REFERENCES characters (character_id)
       		ON UPDATE CASCADE
        	ON DELETE CASCADE
);


CREATE TABLE character_stats (
	character_id INT UNSIGNED NOT NULL PRIMARY KEY,
	health INT UNSIGNED DEFAULT 0,
    	armor INT UNSIGNED DEFAULT 0,
	
    	CONSTRAINT character_stats_fk_characters
		FOREIGN KEY (character_id)
		REFERENCES characters (character_id)
        	ON UPDATE CASCADE
        	ON DELETE CASCADE
);

