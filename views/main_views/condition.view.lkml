# The name of this view in Looker is "Condition"
view: condition {
  sql_table_name: `bigquery-public-data.fhir_synthea.condition` ;;

  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: abatement__date_time {
    type: string
    sql: ${TABLE}.abatement.dateTime ;;
    label: "Abatement Date Time"
  }

  dimension: asserted_date {
    type: string
    sql: ${TABLE}.assertedDate ;;
    hidden: yes
  }

  dimension_group: asserted_ {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: timestamp(${TABLE}.assertedDate) ;;
    convert_tz: no

  }

  dimension: category {
    type: string
    sql: ${TABLE}.category[safe_offset(0)].coding[safe_offset(0)].Display ;;
  }

  dimension: clinical_status {
    type: string
    sql: ${TABLE}.clinicalStatus ;;
  }

  dimension: code__coding {
    hidden: yes
    sql: ${TABLE}.code.coding ;;
    group_label: "Code"
    group_item_label: "Coding"
  }


  dimension: context__encounter_id {
    type: string
    sql: ${TABLE}.context.encounterId ;;
    label:"Encounter ID"
  }

  dimension: verification_status {
    type: string
    sql: ${TABLE}.verificationStatus ;;
  }

  dimension: subject__patient_id {
    type: string
    sql: ${TABLE}.subject.patientId ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  measure: count_patients_total_cond {
    label: "Patients in Condition"
    type: count_distinct
    sql: ${subject__patient_id} ;;
  }

  measure: count_patients_prediabetes_cond {
    label: "Prediabetes Patients Count"
    type: count_distinct
    sql: ${subject__patient_id} ;;
    filters: [condition__code__coding.code: "15777000"]
  }

  measure: count_patients_diabetes_cond {
    label: "Diabetes Patients Count"
    type: count_distinct
    sql: ${subject__patient_id} ;;
    filters: [condition__code__coding.is_diabetes_condition: "Yes"]
  }

}


# The name of this view in Looker is "Condition Code Coding"
view: condition__code__coding {

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
    label: "Condition Code"
  }

  dimension: display {
    type: string
    sql: ${TABLE}.display ;;
    label: "Condition Desc"
  }

  dimension: system {
    type: string
    sql: ${TABLE}.system ;;
    label: "Condition System"
  }

  dimension: is_diabetes_condition {
    type: yesno
    sql: condition__code__coding.code in ('1501000119109', '1551000119108', '60951000119105', '90781000119102', '97331000119101', '157141000119108', '368581000119106') ;;
  }

}
