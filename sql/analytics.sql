CREATE OR REPLACE VIEW ARKANSAS_ATHLETICS.ANALYTICS.V_FOOTBALL_ATTENDANCE AS
SELECT
    season,
    game_date,
    opponent,
    location_type,
    site,
    stadium,
    attendance,
    result,
    arkansas_score,
    opponent_score,
    arkansas_score - opponent_score AS score_margin,
    ABS(arkansas_score - opponent_score) AS absolute_score_margin,

    CASE
        WHEN location_type = 'AWAY' THEN 'AWAY'
        WHEN location_type = 'HOME'
            AND stadium = 'War Memorial Stadium' THEN 'LITTLE ROCK'
        WHEN location_type = 'HOME'
            AND stadium = 'Reynolds Razorback Stadium' THEN 'FAYETTEVILLE'
        WHEN location_type = 'HOME' THEN 'OTHER HOME'
        WHEN location_type = 'NEUTRAL' THEN 'NEUTRAL'
        ELSE 'UNKNOWN'
    END AS venue_group,

    CASE
        WHEN ABS(arkansas_score - opponent_score) <= 7 THEN '0-7'
        WHEN ABS(arkansas_score - opponent_score) <= 14 THEN '8-14'
        ELSE '15+'
    END AS margin_band,

    kickoff_time,

    CASE
        WHEN stadium = 'Reynolds Razorback Stadium'
        THEN attendance - AVG(
            CASE
                WHEN stadium = 'Reynolds Razorback Stadium'
                THEN attendance
            END
        ) OVER ()
    END AS attendance_vs_fayetteville_avg

FROM ARKANSAS_ATHLETICS.ANALYTICS.FOOTBALL_GAMES;
