CREATE OR REPLACE VIEW ARKANSAS_ATHLETICS.ANALYTICS.V_FOOTBALL_ATTENDANCE AS
SELECT
    season,
    game_date,
    opponent,
    location_type,
    stadium,
    attendance,
    result,
    arkansas_score,
    opponent_score,
    arkansas_score - opponent_score AS score_margin,
    kickoff_time
FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES;