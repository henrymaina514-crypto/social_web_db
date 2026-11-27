CREATE TABLE users (
 user_id SERIAL PRIMARY KEY,
 username VARCHAR(50) UNIQUE,
 email VARCHAR(100) UNIQUE,
 full_name VARCHAR(100),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
 post_id SERIAL PRIMARY KEY,
 user_id INTEGER REFERENCES users(user_id),
 content TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
 comment_id SERIAL PRIMARY KEY,
 post_id INTEGER REFERENCES posts(post_id) ON DELETE CASCADE,
 user_id INTEGER REFERENCES users(user_id),
 comment_text TEXT,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE likes (
 like_id SERIAL PRIMARY KEY,
 post_id INTEGER REFERENCES posts(post_id) ON DELETE CASCADE,
 user_id INTEGER REFERENCES users(user_id),
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE(post_id, user_id)
);

INSERT INTO users(username,email,full_name) VALUES
('alexis','alexis@gmail.com','Alexis Maina'),
('brayo','brayo@gmail.com','Brayo Kimani'),
('sahur','sahur@gmail.com','Sahur Wanjiku'),
('daniel','daniel@gmail.com','Daniel Mwangi'),
('maryanne','maryanne@gmail.com','Maryanne Achieng'),
('janet','janet@gmail.com','Janet Njeri');

INSERT INTO posts(user_id,content) VALUES
(1,'Hello everyone'),(2,'Beautiful day'),
(3,'Learning SQL'),(4,'Never give up'),
(5,'Enjoying life'),(1,'My new project'),
(2,'Technology is amazing'),(3,'Have a nice day');

INSERT INTO comments(post_id,user_id,comment_text) VALUES
(1,2,'Welcome'),(1,3,'Nice post'),
(2,1,'True'),(2,4,'Beautiful'),
(3,5,'Keep learning'),(3,1,'I agree'),
(4,2,'Great advice'),(5,3,'Enjoy'),
(6,4,'Good luck'),(7,5,'Amazing');

INSERT INTO likes(post_id,user_id) VALUES
(1,2),(1,3),(1,4),(2,1),(2,3),
(3,1),(3,2),(4,5),(5,1),(6,3);

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM posts WHERE user_id=1;
SELECT * FROM users WHERE username LIKE 'a%';
SELECT * FROM posts WHERE created_at>'2020-01-01';
SELECT * FROM posts ORDER BY created_at DESC;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM posts;
SELECT COUNT(*) FROM comments;

SELECT p.content,u.username
FROM posts p JOIN users u ON p.user_id=u.user_id;

SELECT c.comment_text,u.username
FROM comments c JOIN users u ON c.user_id=u.user_id;

SELECT c.comment_text,p.content
FROM comments c JOIN posts p ON c.post_id=p.post_id;

SELECT p.content,c.comment_text
FROM posts p LEFT JOIN comments c ON p.post_id=c.post_id;

SELECT p.content,COUNT(l.like_id) AS total_likes
FROM posts p LEFT JOIN likes l ON p.post_id=l.post_id
GROUP BY p.post_id,p.content;

SELECT u.username,p.content
FROM users u JOIN posts p ON u.user_id=p.user_id;

BEGIN;

UPDATE users SET full_name='Alex Kamau' WHERE user_id=1;
UPDATE posts SET content='Updated post' WHERE post_id=1;
DELETE FROM comments WHERE comment_id=1;
DELETE FROM posts WHERE post_id=1;

ROLLBACK;

ALTER TABLE users ADD COLUMN bio TEXT;
ALTER TABLE users ADD COLUMN profile_picture VARCHAR(255);
ALTER TABLE users ALTER COLUMN username TYPE VARCHAR(100);
CREATE INDEX idx_posts_user_id ON posts(user_id);

SELECT u.username,COUNT(p.post_id) AS total_posts
FROM users u LEFT JOIN posts p ON u.user_id=p.user_id
GROUP BY u.user_id,u.username;

SELECT p.content,u.username,COUNT(l.like_id) AS total_likes
FROM posts p
JOIN users u ON p.user_id=u.user_id
LEFT JOIN likes l ON p.post_id=l.post_id
GROUP BY p.post_id,p.content,u.username
ORDER BY total_likes DESC LIMIT 5;

SELECT u.username
FROM users u LEFT JOIN posts p ON u.user_id=p.user_id
WHERE p.post_id IS NULL;

SELECT u.username,p.content,c.comment_text
FROM posts p
JOIN users u ON p.user_id=u.user_id
JOIN comments c ON p.post_id=c.post_id;

SELECT * FROM users;
SELECT * FROM posts;
SELECT * FROM comments;
SELECT * FROM likes;