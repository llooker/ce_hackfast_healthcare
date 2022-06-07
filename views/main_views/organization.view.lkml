# The name of this view in Looker is "Organization"
view: organization {
  sql_table_name: `bigquery-public-data.fhir_synthea.organization` ;;

  dimension: org_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    label: "Organization ID"
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: org_type {
    type: string
    sql: ${TABLE}.type[safe_offset(0)].text ;;
  }

  dimension: org_phone_number {
    type: string
    sql: ${TABLE}.telecom[safe_offset(0)].value ;;
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

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.Address[safe_offset(0)].country ;;
    group_label: "Address"
    group_item_label: "Country"
  }

}
