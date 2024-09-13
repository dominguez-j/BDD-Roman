COPY teams
FROM '/teams.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'LATIN1';

COPY matches
FROM '/matches.csv'
DELIMITER ';'
CSV HEADER
ENCODING 'LATIN1';