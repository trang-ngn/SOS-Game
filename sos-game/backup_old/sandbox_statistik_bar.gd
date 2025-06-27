extends TextureRect
class_name StatisticSandbox


func update_houses(houses: int) -> void:
	$HousesLabel.text = str(houses)


func update_stations(stations: int) -> void:
	$StationsLabel.text = str(stations)


func update_coverage(coverage: int, houses: int) -> void:
	$CoverageLabel.text = str(coverage) + "/" + str(houses)
