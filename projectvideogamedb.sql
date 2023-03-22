PROJECT Video Game DataBase

STEP 1: 

video_games_tb = "CREATE TABLE video_games (
id INT PRIMARY KEY,
name VARCHAR(255),
game_genre VARCHAR(255),
game_developer VARCHAR(255),
release_date VARCHAR(255),
CONSTRAINT fk_game_developer
FOREIGN KEY (game_developer)
REFERENCES game_developers(name)
);"
game_developers_tb = "CREATE TABLE game_developers (
id INT PRIMARY KEY,
name VARCHAR(255),
address VARCHAR(255),
state VARCHAR(255),
city VARCHAR(255),
country VARCHAR(255)
);"
platforms_tb = "CREATE TABLE platforms (
id INT PRIMARY KEY,
name VARCHAR(255),
company_id INT,
company VARCHAR(255),
release_date VARCHAR(255),
original_price DECIMAL(10,2),
CONSTRAINT fk_company_id
FOREIGN KEY (company_id)
REFERENCES game_developers(id)
);"
platforms_games_tb = "CREATE TABLE platforms_games (
game_id INT ,
platform_id INT,
platform_name VARCHAR(255),
CONSTRAINT fk_platform_id
FOREIGN KEY (platform_id)
REFERENCES platforms(id),
CONSTRAINT pk_platform_games PRIMARY KEY (game_id,platform_id),
CONSTRAINT fk_game_id
FOREIGN KEY (game_id)
REFERENCES video_games(id)
);"
characters_tb = "CREATE TABLE characters (
id INT PRIMARY KEY,
name VARCHAR(255),
birthday VARCHAR(255),
gender DECIMAL(2,1),
info VARCHAR(255)
);"
games_characters_tb = "CREATE TABLE games_characters (
character_id INT,
character_name VARCHAR(255),
game_id INT,
CONSTRAINT fk_character_id
FOREIGN KEY (character_id)
REFERENCES characters(id),
CONSTRAINT pk_game_characters PRIMARY KEY (character_id,game_id),
CONSTRAINT fk_game_id2
FOREIGN KEY (game_id)
REFERENCES video_games(id)
);"



STEP 2:


delete_rows = "
DELETE 
FROM games_characters
WHERE game_id NOT IN (
SELECT game_id 
FROM games_characters 
WHERE character_id IS NOT NULL
);
"
alter_table_platforms = "
UPDATE platforms
SET release_date = DATE(release_date);
"
alter_table_characters = "
UPDATE characters
SET birthday = DATE(birthday);
"

STEP 3:

search_nathan = "
SELECT character_id, character_name, game_id 
FROM games_characters 
WHERE character_id =
(
SELECT id 
FROM characters 
WHERE name = 'Nathan Drake' 
);
"
how_many_people = "
SELECT count(*) 
FROM characters 
WHERE info LIKE '%Nathan Drake%';
"
find_location = "
SELECT address, state, city, country 
FROM game_developers
WHERE name = (
SELECT game_developer
FROM video_games
WHERE id = (
SELECT game_id
FROM games_characters
WHERE character_name='Nathan Drake'
)
)
;
"

STEP 4:

count_games_ca = "
SELECT COUNT(*) AS num_games
FROM video_games vg
JOIN game_developers gd ON vg.game_developer = gd.name
WHERE gd.state = 'California';
"
address = "
SELECT gd.address, gd.city, gd.state, gd.country
FROM game_developers gd
JOIN video_games vg ON vg.game_developer = gd.name
WHERE gd.state = (
    SELECT state
    FROM game_developers
    GROUP BY state
    ORDER BY COUNT(state) DESC
    LIMIT 1
)
ORDER BY vg.release_date DESC
LIMIT 1;
"
