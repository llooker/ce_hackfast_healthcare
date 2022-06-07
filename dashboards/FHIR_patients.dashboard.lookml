- dashboard: fhir_patients
  title: FHIR Patients
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Top 10 conditions for PreDiabetic patients
    name: Top 10 conditions for PreDiabetic patients
    model: fhir_synthea
    explore: patient_condition
    type: looker_grid
    fields: [condition__code__coding.code, condition__code__coding.display, patient.gender,
      condition.count_patients_total_cond]
    pivots: [patient.gender]
    filters:
      observation.aic_condition: PreDiabetic
    sorts: [patient.gender, condition.count_patients_total_cond desc 0]
    limit: 10
    row_total: right
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 13
    col: 0
    width: 13
    height: 7
  - title: Untitled
    name: Untitled
    model: fhir_synthea
    explore: patient_condition
    type: single_value
    fields: [observation.count_patients_diabetic, observation.ratio_patients_diabetic_v_total]
    limit: 500
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Total Diabetic Patients
    comparison_label: Diabetic Patients vs Total Patients
    defaults_version: 1
    row: 0
    col: 0
    width: 8
    height: 5
  - title: Untitled (Copy)
    name: Untitled (Copy)
    model: fhir_synthea
    explore: patient_condition
    type: single_value
    fields: [observation.count_patients_prediabetic, encounter.encounter_start_year]
    pivots: [encounter.encounter_start_year]
    fill_fields: [encounter.encounter_start_year]
    filters:
      encounter.encounter_start_year: '2018,2019'
    sorts: [encounter.encounter_start_year desc, change 0]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(pivot_offset(${observation.count_patients_prediabetic},0)-pivot_offset(${observation.count_patients_prediabetic},1))/pivot_offset(${observation.count_patients_prediabetic},1)",
        label: "% Change", value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: change, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Pre-Diabetic Patients Current Year
    comparison_label: Percent Change Per Prior Year
    conditional_formatting: [{type: less than, value: 0, background_color: "#7DBE42",
        font_color: !!null '', color_application: {collection_id: inmarket, palette_id: inmarket-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    row: 0
    col: 8
    width: 8
    height: 5
  - title: Untitled (Copy 2)
    name: Untitled (Copy 2)
    model: fhir_synthea
    explore: patient_condition
    type: single_value
    fields: [observation.count_encounters_diabetic, observation.ratio_encounters_prediabetes_v_total]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Diabetes Encounters
    comparison_label: Diabetes Encounters vs Non-Diabetes Encounters
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 0
    col: 16
    width: 8
    height: 5
  - title: A1C Geo Distribution
    name: A1C Geo Distribution
    model: fhir_synthea
    explore: patient_condition
    type: looker_map
    fields: [patient.postal_code_geo, observation.count_patients_diabetic]
    filters:
      observation.aic_condition: "-NULL"
    sorts: [observation.count_patients_diabetic desc]
    limit: 500
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    defaults_version: 1
    listen: {}
    row: 20
    col: 0
    width: 24
    height: 10
  - title: Conditions associated with Diabetes
    name: Conditions associated with Diabetes
    model: fhir_synthea
    explore: patient_condition
    type: looker_grid
    fields: [condition__code__coding.display, condition.count_patients_total_cond,
      condition__code__coding.code]
    filters:
      condition__code__coding.display: "%diab%"
      condition__code__coding.code: "-15777000"
    sorts: [condition.count_patients_total_cond desc]
    limit: 500
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [condition__code__coding.code]
    series_types: {}
    row: 13
    col: 13
    width: 11
    height: 7
  - title: Diabetes patients by year
    name: Diabetes patients by year
    model: fhir_synthea
    explore: condition
    type: looker_line
    fields: [condition.count_patients_total_cond, condition.asserted__year]
    fill_fields: [condition.asserted__year]
    filters:
      condition__code__coding.code: "-15777000"
      condition__code__coding.display: "%diabet%"
    sorts: [condition.asserted__year]
    limit: 500
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    row: 5
    col: 0
    width: 24
    height: 8
