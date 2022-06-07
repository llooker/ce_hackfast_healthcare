# Define the database connection to be used for this model.
connection: "fhir_synthea_sample"

# include all the views
include: "/views/**/*.view"

# include all LookML Dashboards
include: "/dashboards/*.dashboard.lookml"

# Datagroups define a caching policy for an Explore. To learn more,
datagroup: fhir_synthea_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: fhir_synthea_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Fhir Synthea"

explore: patient {
  always_join: [patient__identifier, patient__identifier__type__coding]
  join: patient__identifier {
    view_label: "Patient"
    sql: LEFT JOIN UNNEST(${patient.identifier}) as patient__identifier ;;
    relationship: one_to_many
  }

  join: patient__identifier__type__coding {
    view_label: "Patient"
    fields: []
    required_joins: [patient__identifier]
    sql: LEFT JOIN UNNEST(${patient__identifier.type__coding}) as patient__identifier__type__coding ;;
    relationship: one_to_many
    sql_where: patient__identifier__type__coding.code = 'MR' ;;
  }
}

explore: condition {
  join: condition__code__coding {
    view_label: "Condition"
    sql: LEFT JOIN UNNEST(${condition.code__coding}) as condition__code__coding ;;
    relationship: one_to_many
  }
}

explore: encounter {}

explore: organization {}

explore: observation {
  join: observation__component {
    view_label: "Observation: Component"
    sql: LEFT JOIN UNNEST(${observation.component}) as observation__component ;;
    relationship: one_to_many
  }

}


explore: patient_condition {
  view_name: patient
  always_join: [patient__identifier, patient__identifier__type__coding]
  join: patient__identifier {
    view_label: "Patient"
    sql: LEFT JOIN UNNEST(${patient.identifier}) as patient__identifier ;;
    relationship: one_to_many
  }

  join: patient__identifier__type__coding {
    view_label: "Patient"
    fields: []
    required_joins: [patient__identifier]
    sql: LEFT JOIN UNNEST(${patient__identifier.type__coding}) as patient__identifier__type__coding ;;
    relationship: one_to_many
    sql_where: patient__identifier__type__coding.code = 'MR' ;;
  }
  join: condition {
    type: left_outer
    sql_on: ${patient.id} = ${condition.subject__patient_id} ;;
    relationship: one_to_many
  }
  join: condition__code__coding {
    view_label: "Condition"
    sql: LEFT JOIN UNNEST(${condition.code__coding}) as condition__code__coding ;;
    relationship: one_to_many
  }
  join: encounter {
    type: left_outer
    sql_on: ${condition.context__encounter_id} = ${encounter.encounter_id} and ${condition.subject__patient_id} = ${encounter.encounter_patient_id};;
    relationship: many_to_one
  }
  # join: practitioner {
  #   type: left_outer
  #   sql_on: ${practitioner.id} = ${encounter.encounter_practitioner_id} ;;
  #   relationship:one_to_many
  # }
  join: observation {
    type: left_outer
    sql_on: ${observation.encounter_id} = ${encounter.encounter_id} and ${observation.subject__patient_id} = ${encounter.encounter_patient_id} ;;
    relationship: many_to_one
  }

}
