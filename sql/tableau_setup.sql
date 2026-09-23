---------------------------------------------------------------
-- Tableau / Snowflake Setup
---------------------------------------------------------------
-- Configures Snowflake OAuth and read-only access for Tableau.
-- Intended as one-time environment setup.
--
-- Before running:
-- Replace <SNOWFLAKE_USER> with the Snowflake user that will
-- connect to Tableau.
-- Tableau Desktop also requires the Snowflake ODBC driver.

-- 1. Inspect current Snowflake session
SELECT
    CURRENT_USER(),
    CURRENT_ROLE(),
    CURRENT_WAREHOUSE(),
    CURRENT_DATABASE(),
    CURRENT_SCHEMA();


-- 2. Create Tableau OAuth integration
-- Required for Tableau Desktop to authenticate to Snowflake
-- using OAuth.
USE ROLE ACCOUNTADMIN;

CREATE SECURITY INTEGRATION TABLEAU_DESKTOP_OAUTH
    TYPE = OAUTH
    ENABLED = TRUE
    OAUTH_CLIENT = TABLEAU_DESKTOP;


-- 3. Create read-only Tableau role
CREATE ROLE IF NOT EXISTS TABLEAU_READER;


-- 4. Grant warehouse and database access
GRANT USAGE ON WAREHOUSE SNOWFLAKE_LEARNING_WH
TO ROLE TABLEAU_READER;

GRANT USAGE ON DATABASE ARKANSAS_ATHLETICS
TO ROLE TABLEAU_READER;

GRANT USAGE ON SCHEMA ARKANSAS_ATHLETICS.ANALYTICS
TO ROLE TABLEAU_READER;


-- 5. Grant access to Tableau analytics view
GRANT SELECT ON VIEW
    ARKANSAS_ATHLETICS.ANALYTICS.V_FOOTBALL_ATTENDANCE
TO ROLE TABLEAU_READER;


-- 6. Assign Tableau role to user
-- Replace <SNOWFLAKE_USER> with the appropriate Snowflake user.
GRANT ROLE TABLEAU_READER
TO USER "<SNOWFLAKE_USER>";


-- 7. Verify configuration
SHOW SECURITY INTEGRATIONS;

SHOW GRANTS TO ROLE TABLEAU_READER;

SHOW GRANTS TO USER "<SNOWFLAKE_USER>";

-- ------------------------------------------------------------
-- Tableau Desktop Connection
-- ------------------------------------------------------------
--
-- In Tableau Desktop:
--
--   Connect
--     -> To a Server
--     -> Snowflake
--
-- Enter the following connection settings:
--
--   Server:
--     <ACCOUNT_SERVER_URL>
--
--     Find this in Snowflake:
--       Profile / Account
--       -> Connect a tool to Snowflake
--       -> Account/Server URL
--
--     Example format:
--       <organization>-<account>.snowflakecomputing.com
--
--   Role:
--     TABLEAU_READER
--
--   Warehouse:
--     SNOWFLAKE_LEARNING_WH
--
--   Authentication:
--     Sign in using OAuth
--
-- After OAuth authentication succeeds, select:
--
--   Database:
--     ARKANSAS_ATHLETICS
--
--   Schema:
--     ANALYTICS
--
--   View:
--     V_FOOTBALL_ATTENDANCE
--
-- Recommended connection mode for this project:
--
--   Live
--
-- ------------------------------------------------------------