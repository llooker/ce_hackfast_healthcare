# The name of this view in Looker is "Encounter"
view: encounter {
  sql_table_name: `bigquery-public-data.fhir_synthea.encounter` ;;

  dimension: encounter_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    label: "Encounter ID"
  }

  dimension: encounter_start {
    type: string
    sql: ${TABLE}.period.start ;;
    label: "Encounter Start timestamp"
  }

  dimension: encounter_end {
    type: string
    sql: ${TABLE}.period.end ;;
    label: "Encounter End timestamp"
  }

  dimension_group: encounter_start {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      hour,
      hour_of_day
    ]
    sql: TIMESTAMP(${encounter_start}) ;;
    convert_tz: no
  }

  dimension_group: encounter_duration  {
    type: duration
    sql_start: TIMESTAMP(${encounter_start}) ;;
    sql_end: TIMESTAMP(${encounter_end}) ;;
    intervals: [minute, hour]
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: encounter_type {
    type: string
    sql: ${TABLE}.class.code ;;
  }

  dimension: encounter_patient_id {
    type: string
    sql: ${TABLE}.subject.patientId ;;
    label: "Patient ID"
  }

  dimension: encounter_practitioner_id {
    type: string
    sql: ${TABLE}.participant[safe_OFFSET(0)].individual.practitionerId ;;
  }

  dimension: encounter_location_id {
    type: string
    sql: serviceProvider.organizationId ;;
  }

  dimension: encounter_reason {
    type: string
    sql: type[safe_OFFSET(0)].text ;;
  }

  measure: count {
    type: count
    drill_fields: [encounter_id]
  }
  measure: avg_duration_hr {
    label: "Avg Duration (minutes)"
    type: average
    sql: ${hours_encounter_duration} ;;
    value_format_name: decimal_1
  }

  measure: avg_duration_min {
    type: average
    sql: ${minutes_encounter_duration} ;;
    value_format_name: decimal_1
  }

  measure: count_patients_from_encounter {
    label: "Patients in Encounter"
    type: count_distinct
    sql: ${encounter_patient_id} ;;
  }

}
