# MySQL reproduction

The final SQL was written for MySQL 8.0.16+ and uses the dedicated `scriptsense_strategy` schema. It does not overwrite the earlier `scriptsense_portfolio` draft or any unrelated database. If the final schema already exists, inspect it before importing again; the scripts deliberately do not drop tables.

1. Open a local MySQL connection in Workbench using your own credentials.
2. Run sql/01_schema.sql.
3. Run sql/02_seed_alternative.sql. It inserts exactly the supplied CSV inputs. Alternatively use sql/02_import_csv.sql after changing the folder path. Choose ONE route, not both.
4. Run sql/03_views.sql, sql/05_quality_checks.sql, then sql/04_analysis.sql.
5. Compare results with data/processed and docs/validation.md. Queries Q1–Q9 cover the business decisions; Q10 adds annual recovery checkpoints.

CSV files are UTF-8, LF newline, with one header. Import tiers, assumptions, scenarios and customers in that order. LOAD DATA LOCAL requires client and server support; the seed route avoids changing local-file settings. Inspect SHOW WARNINGS after each CSV load. Do not ignore duplicate primary-key errors or partially imported data.

The Excel dashboard is a self-contained snapshot using the same input rows and formulas, not a live database connection. Its saved baseline reconciles with SQL. If you change assumptions in Excel, SQL stays unchanged until you also update its input tables and rerun the views/queries. No credentials, database files or connections are embedded in the workbook.

Source references: https://dev.mysql.com/doc/refman/8.4/en/loading-tables.html and https://dev.mysql.com/doc/refman/8.4/en/load-data-local-security.html. These references explain import behavior, not the fictional financial assumptions.
