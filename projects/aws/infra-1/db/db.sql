USE nodedb;

CREATE TABLE publications (
    name VARCHAR(250) NOT NULL,
    avatar VARCHAR(250) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE reviewers (
    name VARCHAR(255) NOT NULL,
    publication VARCHAR(250) DEFAULT NULL,
    avatar VARCHAR(250) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE movies (
    title VARCHAR(250) NOT NULL,
    release_year VARCHAR(250) NOT NULL,
    score INT(11) NOT NULL,
    reviewer VARCHAR(250) NOT NULL,
    publication VARCHAR(250) NOT NULL,
    FOREIGN KEY (reviewer) REFERENCES reviewers(name),
    FOREIGN KEY (publication) REFERENCES publications(name),
    PRIMARY KEY (title, release_year)
);