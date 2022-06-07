# The name of this view in Looker is "Practitioner"
# view: practitioner {
#   sql_table_name: `bigquery-public-data.fhir_synthea.practitioner` ;;

  # dimension: id {
  #   primary_key: yes
  #   type: string
  #   sql: ${TABLE}.id ;;
  # }

  # dimension: gender {
  #   type: string
  #   sql: ${TABLE}.gender ;;
  # }

  # dimension: prefix_name {
  #   type: string
  #   sql: ${TABLE}.name[safe_offset(0)].prefix[safe_offset(0)] ;;
  #   group_label: "Name"
  # }

  # dimension: given_name {
  #   type: string
  #   sql: ${TABLE}.name[safe_offset(0)].given[safe_offset(0)] ;;
  #   group_label: "Name"
  # }

  # dimension: family_name {
  #   type: string
  #   sql: ${TABLE}.name[safe_offset(0)].family ;;
  #   group_label: "Name"
  # }

  # dimension: full_name {
  #   type: string
  #   sql: concat(${prefix_name},' ', ${given_name}, ' ', ${family_name}) ;;
  #   group_label: "Name"
  # }

  # dimension: address_line {
  #   type: string
  #   sql: ${TABLE}.Address[safe_offset(0)].line[safe_offset(0)] ;;
  #   group_label: "Address"
  #   group_item_label: "Address Line"
  # }

  # dimension: city {
  #   type: string
  #   sql: ${TABLE}.Address[safe_offset(0)].city ;;
  #   group_label: "Address"
  #   group_item_label: "City"
  # }

  # dimension: state {
  #   type: string
  #   sql: ${TABLE}.Address[safe_offset(0)].state ;;
  #   group_label: "Address"
  #   group_item_label: "State"
  # }

  # dimension: postal_code {
  #   type: string
  #   sql: ${TABLE}.Address[safe_offset(0)].postalCode ;;
  #   group_label: "Address"
  #   group_item_label: "Postal Code"
  # }

  # dimension: country {
  #   type: string
  #   map_layer_name: countries
  #   sql: ${TABLE}.Address[safe_offset(0)].country ;;
  #   group_label: "Address"
  #   group_item_label: "Country"
  # }

# }
