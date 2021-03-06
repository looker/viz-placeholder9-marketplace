explore: date_table_core {
  extension: required
  from: zip_codes
  group_label: "Google Demand Live Events"
  view_label: "Location"
  label: "Live Events - Main"

  join: let_events {
    view_label: "Live Events"
    type: left_outer
    relationship: many_to_many
    sql_on: ${date_table.calendar_date} = ${let_events.local_event_datetime_date} AND ${date_table.zip_code} = ${let_events.zip_code};;
  }

  join: livestream_clean {
    view_label: "Livestream Events"
    type: left_outer
    relationship: one_to_many
    sql_on: ${date_table.calendar_date} = ${livestream_clean.start_date} ;;
  }

  join: us_counties {
    view_label: "Covid-19"
    type: left_outer
    relationship: many_to_one
    sql_on: ${date_table.calendar_date} = ${us_counties.measurement_date} AND ${date_table.county} = ${us_counties.county} AND ${us_counties.pk} IS NOT NULL;;
  }

  join: mobility_data_core {
    view_label: "Mobility (US)"
    type: left_outer
    relationship: many_to_one
    sql_on:${date_table.calendar_date} = ${mobility_data_core.mobility_date} AND ${date_table.county} = ${mobility_data_core.sub_region_2} AND ${mobility_data_core.country_region} = 'United States' ;;
  }

  join: max_date_mobility {
    type: left_outer
    relationship: many_to_one
    view_label: "Mobility (US)"
    fields: [max_date_mobility.max_mobility_raw]
    sql_on: ${mobility_data_core.mobility_date} = ${max_date_mobility.max_mobility_raw} ;;
  }

  join: max_measurement_date {
    type: left_outer
    relationship: one_to_one
    sql_on: ${us_counties.measurement_date} = ${max_measurement_date.max_measurement_date} ;;
  }

  join: weather {
    view_label: "Weather"
    type: left_outer
    relationship: many_to_many
    sql_on: ${date_table.calendar_date} = ${weather.weather_date} AND ${us_counties.fips} = ${weather.fips} ;;
  }

  join: expected_weather_by_state {
    view_label: "Weather"
    type: left_outer
    relationship: many_to_many
    sql_on: ${date_table.state_fips_code} = ${expected_weather_by_state.state_fips} AND CAST(${date_table.calendar_day_of_year} AS INT64) = ${expected_weather_by_state.calendar_day_of_year} ;;
  }
}
