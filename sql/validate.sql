-- Validate the expected number of games
SELECT COUNT(*) AS game_count
FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES;

-- Check for duplicate games based on game date and opponent
SELECT
    game_date,
    opponent,
    COUNT(*) AS duplicate_count
FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES
GROUP BY game_date, opponent
HAVING COUNT(*) > 1;

-- Check for missing or invalid attendance values
SELECT *
FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES
WHERE attendance IS NULL
   OR attendance <= 0;

-- Inspect all games in chronological order
SELECT *
FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES
ORDER BY game_date;