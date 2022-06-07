# The name of this view in Looker is "Observation"
view: observation {
  sql_table_name: `bigquery-public-data.fhir_synthea.observation` ;;

  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.id ;;
    label: "Obervation ID"
  }

  dimension: encounter_id {
    type: string
    sql: ${TABLE}.context.encounterId ;;
    label: "Encounter ID"
  }

  dimension: subject__patient_id {
    type: string
    sql: ${TABLE}.subject.patientId ;;
    label: "Patient ID"
  }

  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: issued {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.issued ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category[safe_offset(0)].coding[safe_offset(0)].display ;;
    label: "Observation Category"
    description: "provide the category of the observation during the encounter such as vital signs, surgury, lab results"
  }

  dimension: code__coding {
    sql: ${TABLE}.code.coding[safe_offset(0)].code ;;
    group_label: "Code"
    group_item_label: "Coding"
  }

  dimension: code__coding__desc {
    sql: ${TABLE}.code.coding[safe_offset(0)].display ;;
    group_label: "Code"
    group_item_label: "Description"
  }

  dimension: code__text {
    type: string
    sql: ${TABLE}.code.text ;;
    group_label: "Code"
    group_item_label: "Text"
  }

  dimension: value__quantity__unit {
    type: string
    sql: ${TABLE}.value.quantity.unit ;;
    group_label: "Value Quantity"
    group_item_label: "Unit"
  }

  dimension: value__quantity__value {
    type: number
    sql: ${TABLE}.value.quantity.value ;;
    group_label: "Value Quantity"
    group_item_label: "Value"
  }

  dimension: value__string {
    type: string
    sql: ${TABLE}.value.string ;;
    group_label: "Value"
    group_item_label: "String"
  }

  dimension: component {
    hidden: yes
    sql: ${TABLE}.component ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

  dimension: aic_condition {
    label: "A1C Status"
    type: string
    sql: case
          when ${value__quantity__value} >= 6.7 and ${code__text} like '%A1c/Hemoglobin%' and ${status}='final' then 'Diabetic'
          when ${value__quantity__value} <= 5.7 and ${code__text} like '%A1c/Hemoglobin%' and ${status}='final' then 'Normal'
          when ${value__quantity__value} > 5.7 and ${value__quantity__value} < 6.5 and ${code__text} like '%A1c/Hemoglobin%' and ${status}='final' then 'PreDiabetic'
        end ;;
  }

  measure: count_patients_total  {
    label: "Patient Count - Total"
    type: count_distinct
    sql: ${subject__patient_id} ;;
  }

  measure: count_patients_diabetic {
    label: "Patient Count - Diabetes"
    type: count_distinct
    sql: ${subject__patient_id} ;;
    filters: [aic_condition: "Diabetic"]
  }

  measure: count_patients_prediabetic {
    label: "Patient Count - PreDiabetes"
    type: count_distinct
    sql: ${subject__patient_id} ;;
    filters: [aic_condition: "PreDiabetic"]
  }

  measure: count_patients_normal {
    label: "Patient Count - Normal AIC"
    hidden: yes
    type: count_distinct
    sql: ${subject__patient_id} ;;
    filters: [aic_condition: "Normal"]
  }

  measure: count_patients_non_diabetes  {
    label: "Patient Count - Non-Diabetes"
    type: number
    sql:  ${count_patients_total} - ${count_patients_diabetic} - ${count_patients_prediabetic} ;;
  }

  measure: ratio_patients_diabetic_v_total {
    label: "Patient Count Ratio - Diabetes vs Total"
    type: number
    sql: ${count_patients_diabetic} / NULLIF(${count_patients_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_patients_prediabetic_v_total {
    label: "Patient Count Ratio - PreDiabetes vs Total"
    type: number
    sql: ${count_patients_prediabetic} / NULLIF(${count_patients_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_patients_nondiabetic_v_total {
    label: "Patient Count Ratio - Non-Diabetes vs Total"
    type: number
    sql: ${count_patients_non_diabetes} / NULLIF(${count_patients_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_patients_diabetic_v_nondiabetic {
    label: "Patient Count Ratio - Diabetes vs Non-Diabetes"
    type: number
    sql:  ${count_patients_diabetic} / NULLIF(${count_patients_non_diabetes},0) ;;
    value_format_name: percent_2
  }

  measure: count_encounters_total {
    label: "Encounter Visits - Total"
    type:  count_distinct
    sql: ${encounter_id} ;;
  }

  measure: count_encounters_diabetic {
    label: "Encounter Visits - Diabetes"
    type: count_distinct
    sql: ${encounter_id} ;;
    filters: [aic_condition: "Diabetic"]
  }

  measure: count_encounters_prediabetic {
    label: "Encounter Visits - PreDiabetes"
    type: count_distinct
    sql: ${encounter_id} ;;
    filters: [aic_condition: "PreDiabetic"]
  }

  measure: count_encounters_nondiabetic {
    label: "Encounter Visits - Non-Diabetes"
    type: number
    sql: ${count_encounters_total} - ${count_encounters_diabetic} - ${count_encounters_prediabetic} ;;
  }

  measure: ratio_encounters_diabetes_v_total {
    label: "Encounter Visit Ratio - Diabetes vs Total"
    type: number
    sql: ${count_encounters_diabetic} / NULLIF(${count_encounters_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_encounters_prediabetes_v_total {
    label: "Encounter Visit Ratio - PreDiabetes vs Total"
    type: number
    sql: ${count_encounters_prediabetic} / NULLIF(${count_encounters_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_encounters_nondiabetes_v_total {
    label: "Encounter Visit Ratio - Non-Diabetes vs Total"
    type: number
    sql: ${count_encounters_nondiabetic} / NULLIF(${count_encounters_total},0) ;;
    value_format_name: percent_2
  }

  measure: ratio_encounters_diabetes_v_non {
    label: "Encounter Visit Ratio - Diabetes vs Non-Diabetes"
    type: number
    sql: ${count_encounters_diabetic} / NULL(${count_encounters_nondiabetic},0) ;;
    value_format_name: percent_2
  }

}

# The name of this view in Looker is "Observation Component"
view: observation__component {
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # This field is hidden, which means it will not show up in Explore.
  # If you want this field to be displayed, remove "hidden: yes".

  dimension: code__coding {
    hidden: yes
    sql: ${TABLE}.code.coding ;;
    group_label: "Code"
    group_item_label: "Coding"
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Code Text" in Explore.

  dimension: code__text {
    type: string
    sql: ${TABLE}.code.text ;;
    group_label: "Code"
    group_item_label: "Text"
  }

  # dimension: value__quantity__code {
  #   type: string
  #   sql: ${TABLE}.value.quantity.code ;;
  #   group_label: "Value Quantity"
  #   group_item_label: "Code"
  # }

  dimension: value__quantity__system {
    type: string
    sql: ${TABLE}.value.quantity.system ;;
    group_label: "Value Quantity"
    group_item_label: "System"
  }

  dimension: value__quantity__unit {
    type: string
    sql: ${TABLE}.value.quantity.unit ;;
    group_label: "Value Quantity"
    group_item_label: "Unit"
  }

  dimension: value__quantity__value {
    type: number
    sql: ${TABLE}.value.quantity.value ;;
    group_label: "Value Quantity"
    group_item_label: "Value"
  }

}

# The name of this view in Looker is "Observation Component Code Coding"
# view: observation__component__code__coding {
#   # No primary key is defined for this view. In order to join this view in an Explore,
#   # define primary_key: yes on a dimension that has no repeated values.

#   # Here's what a typical dimension looks like in LookML.
#   # A dimension is a groupable field that can be used to filter query results.
#   # This dimension will be called "Code" in Explore.

#   dimension: code {
#     type: string
#     sql: ${TABLE}.code ;;
#   }

#   dimension: display {
#     type: string
#     sql: ${TABLE}.display ;;
#   }

#   dimension: system {
#     type: string
#     sql: ${TABLE}.system ;;
#   }

# }
