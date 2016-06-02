CREATE TABLE modules (
    id      SERIAL PRIMARY KEY NOT NULL,
    name    text,
    version text
);

CREATE TABLE pod (
    id          SERIAL PRIMARY KEY NOT NULL,
    module_id   integer REFERENCES modules(id) ON DELETE CASCADE ON UPDATE CASCADE,
    identifier  text,
    title       text,
    content     text
);

INSERT INTO modules (name, version) VALUES ('Testing', '1.0');
