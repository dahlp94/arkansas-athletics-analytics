# Arkansas Football Analytics

An end-to-end analytics project that transforms public Arkansas football data into a validated Snowflake reporting layer and Tableau dashboard.

**Tech:** Python, SQL, Snowflake, Tableau

## Overview

This project builds a simple analytics pipeline for the 2025 Arkansas football season:

**Public data → Python → Snowflake → SQL → Tableau**

The dataset contains 12 games with attendance, opponent, location, stadium, result, scores, and game context.

## What I Built

- Prepared a clean game-level dataset with Python
- Loaded and modeled the data in Snowflake
- Added SQL checks for completeness, duplicates, and invalid values
- Created a reporting-ready analytics view for Tableau
- Configured OAuth and a read-only Snowflake role for BI access
- Connected Tableau directly to Snowflake using a live connection
- Built game-level attendance reporting and dashboard components

## Dashboard

The Tableau dashboard is designed to highlight:

- Total and average attendance
- Attendance by game
- Attendance by location
- Game results and score margins
- Game-level detail

## Project Structure

```text
src/
└── build_dataset.py

sql/
├── create_table.sql
├── validate.sql
├── analytics.sql
└── tableau_setup.sql
````

## Current Status

The full Python → Snowflake → SQL → Tableau pipeline is working end to end.

Dashboard development is in progress, with the attendance-by-game visualization completed and validated against the Snowflake reporting layer.