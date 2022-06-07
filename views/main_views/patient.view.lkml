# The name of this view in Looker is "Patient"
view: patient {
  sql_table_name: `bigquery-public-data.fhir_synthea.patient` ;;

  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: given_name {
    type: string
    sql: ${TABLE}.name[safe_offset(0)].given[safe_offset(0)] ;;
    group_label: "Name"
  }

  dimension: family_name {
    type: string
    sql: ${TABLE}.name[safe_offset(0)].family ;;
    group_label: "Name"
  }

  dimension: full_name {
    type: string
    sql: concat(${given_name}, ' ', ${family_name}) ;;
    group_label: "Name"
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}.telecom[safe_offset(0)].value ;;
  }

  dimension: birth_date {
    type: string
    sql: ${TABLE}.birthDate ;;
  }

  dimension: deceased__date_time {
    label: "Deceased Date/Time"
    type: string
    sql: ${TABLE}.deceased.dateTime ;;
  }

  dimension: is_desceased {
    type: yesno
    sql: ${deceased__date_time} is not null ;;
  }

  dimension: age {
    type: number
    sql:
    case when patient.deceased.dateTime is not null
      then date_diff(date(patient.deceased.dateTime), date(patient.birthDate), year)
    else
    date_diff(current_date(), date(patient.birthDate), year) + IF(EXTRACT(DAYOFYEAR FROM current_date()) < EXTRACT(DAYOFYEAR FROM date(patient.birthDate)), -1, 0)
    end ;;
    description: "Age of the patient based on current date - birth date, unless deceased then deceased date - birthdate"
  }

  dimension: age_tier {
    type: bin
      bins: [0, 10, 20, 30, 40, 50, 60, 70, 80, 90]
      style: integer
      sql: ${age} ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: address_line {
    type: string
    sql: ${TABLE}.Address[safe_offset(0)].line[safe_offset(0)] ;;
    group_label: "Address"
    group_item_label: "Address Line"
  }

  dimension: city {
    type: string
    sql: ${TABLE}.Address[safe_offset(0)].city ;;
    group_label: "Address"
    group_item_label: "City"
  }

  dimension: state {
    type: string
    sql: ${TABLE}.Address[safe_offset(0)].state ;;
    group_label: "Address"
    group_item_label: "State"
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.Address[safe_offset(0)].postalCode ;;
    group_label: "Address"
    group_item_label: "Postal Code"
  }

  dimension: postal_code_geo {
    type: zipcode
    sql: ${TABLE}.Address[safe_offset(0)].postalCode ;;
    group_label: "Geolocation"
    group_item_label: "Postal Code"
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.Address[safe_offset(0)].country ;;
    group_label: "Address"
    group_item_label: "Country"
  }

    dimension: geolocation__latitude__value__decimal {
    type: number
    sql: ${TABLE}.Address[safe_offset(0)].geolocation.latitude.value.decimal ;;
    group_label: "Geolocation"
    group_item_label: "latitude"
  }

    dimension: geolocation__longitude__value__decimal {
    type: number
    sql: ${TABLE}.Address[safe_offset(0)].geolocation.longitude.value.decimal ;;
    group_label: "Geolocation"
    group_item_label: "longitude"
  }

  dimension: geo_location {
    type: location
    sql_latitude: ${geolocation__latitude__value__decimal} ;;
    sql_longitude: ${geolocation__longitude__value__decimal} ;;
  group_label: "Geolocation"
  group_item_label: "Geo Location"
  }

  dimension: identifier {
    hidden: yes
    sql: ${TABLE}.identifier ;;
  }

  measure: count_patients_total_all {
    label: "Total Population"
    type: count_distinct
    sql: ${id} ;;
  }

}

view: patient__identifier {

  dimension: value {
    type: string
    sql: value ;;
    label: "MRN"
  }

  dimension: type__coding {
    hidden: yes
    sql: type.coding ;;
    group_label: "Type"
    group_item_label: "Coding"
  }

}

view: patient__identifier__type__coding {

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: display {
    type: string
    sql: ${TABLE}.display ;;
  }

  dimension: system {
    type: string
    sql: ${TABLE}.system ;;
  }

  dimension: user_selected {
    type: yesno
    sql: ${TABLE}.userSelected ;;
  }

  dimension: version {
    type: string
    sql: ${TABLE}.version ;;
  }
}
