INSERT INTO fruit(id, name, category, notes) VALUES (nextval('hibernate_sequence'), 'Cherry', 'Berry', '1.2.3.4');
INSERT INTO fruit(id, name, category, notes) VALUES (nextval('hibernate_sequence'), 'Apple', 'Berry', 'Debian (buster)');
INSERT INTO fruit(id, name, category, notes) VALUES (nextval('hibernate_sequence'), 'Banana', 'Misc', 'P@55w0rd!');

INSERT INTO user(id, name, email, password) VALUES (nextval('hibernate_sequence'), 'admin', 'admin@admin.adm', 'P@55w0rd!');