class_name Statistic extends TextureRect

@onready var number_label: Label = $NumberLabel
@onready var coverage_label: Label = $CoverageLabel
@onready var cost_label: Label = $CostLabel


func update_number(number: int, total_number: int) -> void:
	number_label.text = str(number) + "/" + str(total_number)


func update_coverage(coverage: int, total_coverage: int) -> void:
	coverage_label.text = str(coverage) + "/" + str(total_coverage)


func update_cost(total_cost: float) -> void:
	cost_label.text = str(int(total_cost)) + "M €"
