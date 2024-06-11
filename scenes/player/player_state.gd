class_name PlayerState
extends Node

enum State {BASE, ACTION}

signal transition_requested(from: PlayerState, to: State)

@export var state: State

func enter():
	pass

func exit():
	pass
