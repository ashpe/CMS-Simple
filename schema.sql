CREATE TABLE login(username TEXT PRIMARY KEY NOT NULL, user_level INTEGER NOT NULL, password TEXT NOT NULL);
CREATE TABLE data_check(username TEXT NOT NULL, filename TEXT PRIMARY KEY NOT NULL, last_modified TEXT NOT NULL);
INSERT INTO data_check values('tmp', 'tmp', '123');
