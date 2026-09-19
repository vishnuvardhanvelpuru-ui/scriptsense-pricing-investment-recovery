-- Final case: MySQL 8.0.16+. New schema name protects the earlier draft database.
CREATE DATABASE IF NOT EXISTS scriptsense_strategy CHARACTER SET utf8mb4;
USE scriptsense_strategy;
CREATE TABLE tiers (
 tier_id INT PRIMARY KEY,tier_name VARCHAR(30) NOT NULL UNIQUE,
 list_monthly_inr DECIMAL(12,2) NOT NULL CHECK(list_monthly_inr>0),
 proposed_increase DECIMAL(6,4) NOT NULL CHECK(proposed_increase BETWEEN 0 AND 1),
 included_script_runs INT NOT NULL CHECK(included_script_runs>0),
 overage_per_run_inr DECIMAL(10,2) NOT NULL CHECK(overage_per_run_inr>=0)
);
CREATE TABLE assumptions (
 assumption_id INT PRIMARY KEY CHECK(assumption_id=1),
 initial_investment_inr DECIMAL(14,2) NOT NULL CHECK(initial_investment_inr>0),
 fixed_monthly_cost_inr DECIMAL(12,2) NOT NULL CHECK(fixed_monthly_cost_inr>=0),
 target_payback_months INT NOT NULL CHECK(target_payback_months>0),
 review_margin DECIMAL(6,4) NOT NULL CHECK(review_margin BETWEEN 0 AND 1)
);
CREATE TABLE scenarios (
 scenario_id INT PRIMARY KEY,scenario_name VARCHAR(30) NOT NULL UNIQUE,
 adoption_rate DECIMAL(6,4) NOT NULL CHECK(adoption_rate BETWEEN 0 AND 1),
 retention_rate DECIMAL(6,4) NOT NULL CHECK(retention_rate BETWEEN 0 AND 1)
);
CREATE TABLE customers (
 customer_id CHAR(4) PRIMARY KEY,customer_name VARCHAR(60) NOT NULL,
 segment VARCHAR(40) NOT NULL,tier_id INT NOT NULL,snapshot_date DATE NOT NULL,
 monthly_script_runs INT NOT NULL CHECK(monthly_script_runs>0),
 contracted_monthly_inr DECIMAL(12,2) NOT NULL CHECK(contracted_monthly_inr>0),
 hosting_monthly_inr DECIMAL(12,2) NOT NULL CHECK(hosting_monthly_inr>=0),
 support_hours_monthly DECIMAL(8,2) NOT NULL CHECK(support_hours_monthly>=0),
 support_hourly_cost_inr DECIMAL(10,2) NOT NULL CHECK(support_hourly_cost_inr>=0),
 FOREIGN KEY(tier_id) REFERENCES tiers(tier_id)
);
