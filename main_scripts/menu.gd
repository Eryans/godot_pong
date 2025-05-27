extends Control

@onready var one_player_mode_button: Button = %OnePlayerMode;
@onready var two_players_mode_button: Button = %TwoPlayersMode;
@onready var quit_button: Button = %Quit;

@onready var main_scene: PackedScene = preload("uid://caaf5w2sa0uvv")

func _ready() -> void:
    one_player_mode_button.pressed.connect(_on_button_click);
    two_players_mode_button.pressed.connect(_on_button_click);
    quit_button.pressed.connect(_on_button_click);

    one_player_mode_button.mouse_entered.connect(_on_button_hover);
    two_players_mode_button.mouse_entered.connect(_on_button_hover);
    quit_button.mouse_entered.connect(_on_button_hover);

    one_player_mode_button.pressed.connect(_one_player_button_pressed);
    two_players_mode_button.pressed.connect(_two_players_button_pressed);
    quit_button.pressed.connect(_quit_button_pressed);

func _one_player_button_pressed() -> void:
    GameGlobal.is_two_player_mode = false;
    get_tree().change_scene_to_packed(main_scene)

func _two_players_button_pressed() -> void:
    GameGlobal.is_two_player_mode = true;
    get_tree().change_scene_to_packed(main_scene)

func _quit_button_pressed() -> void:
    pass

func _on_button_hover() -> void:
    EventManager.button_hover_emit()
    pass

func _on_button_click() -> void:
    EventManager.button_click_emit()
    pass