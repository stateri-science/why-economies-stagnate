CREATE VIEW stagnation_panel AS
SELECT
    iso3,
    name,
    region,
    income_group,
    year,
    CASE
        WHEN iso3 IN ('PHL','BRA','ZAF','MEX') THEN 'stagnation'
        ELSE 'comparator'
    END AS country_role,
    gdp_pc_growth_yoy,
    gdp_per_employed_const,
    gfcf_pct_gdp,
    gross_savings_pct_gdp,
    va_manufacturing_pct_gdp,
    va_services_pct_gdp,
    enrolment_tertiary_gross_pct,
    tax_revenue_pct_gdp,
    poverty_215_headcount_pct,
    gini_idx,
    unemployment_pct,
    trade_openness_pct_gdp,
    fdi_inflows_pct_gdp
FROM panel_wide
WHERE iso3 IN ('PHL','BRA','ZAF','MEX','IDN','VNM','POL','MYS','CHL')
  AND year >= 1990
ORDER BY iso3, year;