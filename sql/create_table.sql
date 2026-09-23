CREATE DATABASE IF NOT EXISTS ARKANSAS_ATHLETICS;

CREATE SCHEMA IF NOT EXISTS ARKANSAS_ATHLETICS.ANALYTICS;

CREATE OR REPLACE TABLE ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES (
    season INTEGER,
    game_date DATE,
    opponent VARCHAR,
    location_type VARCHAR,
    arkansas_score INTEGER,
    opponent_score INTEGER,
    result VARCHAR,
    site VARCHAR,
    stadium VARCHAR,
    attendance INTEGER,
    kickoff_time TIME,
    source_url VARCHAR
);
