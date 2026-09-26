library(tidyverse)

# Load the processed data
df <- read_csv("C:\\Users\\Erica\\Desktop\\Portfolio\\data\\processed\\stagnation_panel_1990_2024.csv")

# Quick structure check
glimpse(df)
summary(df)

df %>%
  group_by(country_role) %>%
  summarise(
    n_obs = n(),
    avg_gdp_pc_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE),
    avg_gfcf = mean(gfcf_pct_gdp, na.rm = TRUE),
    avg_savings = mean(gross_savings_pct_gdp, na.rm = TRUE),
    avg_manuf_share = mean(va_manufacturing_pct_gdp, na.rm = TRUE),
    avg_trade_openness = mean(trade_openness_pct_gdp, na.rm = TRUE),
    avg_fdi = mean(fdi_inflows_pct_gdp, na.rm = TRUE)
  )

df %>%
  group_by(year, country_role) %>%
  summarise(avg_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_growth, color = country_role)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  labs(
    title = "GDP per Capita Growth: Stagnation vs. Comparator Economies (1990-2024)",
    x = "Year", y = "Average GDP per Capita Growth (%)",
    color = "Group"
  ) +
  theme_minimal()


t.test(gdp_pc_growth_yoy ~ country_role, data = df)


# Regression
model <- lm(gdp_pc_growth_yoy ~ gfcf_pct_gdp + trade_openness_pct_gdp + country_role, data = df)
summary(model)

model2 <- lm(gdp_pc_growth_yoy ~ gfcf_pct_gdp + trade_openness_pct_gdp + va_manufacturing_pct_gdp + country_role, data = df)
summary(model2)



# Does the gap change across ages?
df %>%
  mutate(decade = case_when(
    year >= 1990 & year <= 1999 ~ "1990s",
    year >= 2000 & year <= 2009 ~ "2000s",
    year >= 2010 & year <= 2019 ~ "2010s",
    year >= 2020 ~ "2020s",
  )) %>%
  group_by(decade, country_role) %>%
  summarise(avg_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE), .groups = "drop") %>%
  pivot_wider(names_from = country_role, values_from = avg_growth) %>%
  mutate(gap = comparator - stagnation)

df %>%
  mutate(decade = case_when(
    year >= 1990 & year <= 1999 ~ "1990s",
    year >= 2000 & year <= 2009 ~ "2000s",
    year >= 2010 & year <= 2019 ~ "2010s",
    year >= 2020 ~ "2020s",
  )) %>%
  group_by(decade, country_role) %>%
  summarise(avg_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = decade, y = avg_growth, fill = country_role)) +
  geom_col(position = "dodge") +
  labs(
    title = "GDP per Capita Growth by Decade: Stagnation vs. Comparator",
    x = "Decade", y = "Average GDP per Capita Growth (%)",
    fill = "Group"
  ) +
  theme_minimal()

# Poverty and Inequality
df %>%
  filter(!is.na(poverty_215_headcount_pct)) %>%
  group_by(iso3, name, country_role) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  select(iso3, name, country_role, year, poverty_215_headcount_pct, gini_idx) %>%
  arrange(country_role, iso3)

df %>%
  filter(!is.na(poverty_215_headcount_pct)) %>%
  group_by(iso3, name, country_role) %>%
  filter(year == max(year)) %>%
  ungroup() %>%
  select(iso3, name, country_role, year, poverty_215_headcount_pct, gini_idx) %>%
  arrange(country_role, iso3)



#Plot 1: Growth trend over time
p1 <- df %>%
  group_by(year, country_role) %>%
  summarise(avg_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = year, y = avg_growth, color = country_role)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
  labs(
    title = "GDP per Capita Growth: Stagnation vs. Comparator Economies (1990-2024)",
    x = "Year", y = "Average GDP per Capita Growth (%)",
    color = "Group"
  ) +
  theme_minimal()

p1


#Plot 2: Growth by decade
p2 <- df %>%
  mutate(decade = case_when(
    year >= 1990 & year <= 1999 ~ "1990s",
    year >= 2000 & year <= 2009 ~ "2000s",
    year >= 2010 & year <= 2019 ~ "2010s",
    year >= 2020 ~ "2020s",
  )) %>%
  group_by(decade, country_role) %>%
  summarise(avg_growth = mean(gdp_pc_growth_yoy, na.rm = TRUE), .groups = "drop") %>%
  ggplot(aes(x = decade, y = avg_growth, fill = country_role)) +
  geom_col(position = "dodge") +
  labs(
    title = "GDP per Capita Growth by Decade: Stagnation vs. Comparator",
    x = "Decade", y = "Average GDP per Capita Growth (%)",
    fill = "Group"
  ) +
  theme_minimal()

p2