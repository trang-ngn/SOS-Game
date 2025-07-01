extends GutTest
# GUT creates a test scene in the background and executes your test scripts there
# test script is also a Node inside the test scene


"""
does the scene load without crashing?
are all expected UI elements present?
"""
var main_scene: PackedScene
var root: Node2D # root of scene

func before_all():
	main_scene = preload("res://main.tscn") # resources are loaded before scene is playing/running
	if main_scene == null:
		fail_test("Fail to load main.tscn.")

func before_each():
	root = main_scene.instantiate() # xreate the node hierarchy (but not yet active)
	if root == null:
		fail_test("Fail to instantiate the root of main.tscn.")
	add_child_autoqfree(root) # add to test scene tree (will be automatically cleaned up)
	await get_tree().process_frame # wait until test node finishes adding child nodes

func after_each():
	await get_tree().process_frame # wait for clean up to complete
	# now GUT checks for unfreed children

func test_main_scene_uid():
	var main_scene_uid = ProjectSettings.get_setting("application/run/main_scene")
	var expected_uid = "uid://ckvhkw0kla0c1"
	assert_eq(main_scene_uid, expected_uid, "Main scene is set incorrectly.")

func test_startmenu_has_expected_buttons():
	var start_menu = root.get_node("StartMenu")
	assert_not_null(start_menu, "Missing node: StartMenu")
	if start_menu == null:
		return 
	
	var buttons = root.get_node("StartMenu/Buttons")
	assert_not_null(buttons, "Missing all buttons")
	if buttons == null:
		return
		
	var start_button = buttons.get_node("StartButton")
	assert_not_null(start_button, "Missing button: StartButton")
	
	
	var sandbox_button = buttons.get_node("SandboxButton")
	assert_not_null(sandbox_button, "Missing button: SandboxButton")
	
	var help_button = buttons.get_node("HelpButton")
	assert_not_null(help_button, "Missing button: HelpButton")
	
	
	
