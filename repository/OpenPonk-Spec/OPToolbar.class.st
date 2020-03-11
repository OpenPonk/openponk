"
I am a group of (related) buttons.

!! Responsibility

!! Collaborators

(depending on type)
DCEditor
DCWorkbench
DCCanvasModel

!! Usage





"
Class {
	#name : #OPToolbar,
	#superclass : #ComposablePresenter,
	#instVars : [
		'menu',
		'menuModel',
		'groupModel'
	],
	#category : #'OpenPonk-Spec-Toolbars'
}

{ #category : #specs }
OPToolbar class >> defaultSpec [
	^ SpecLayout composed
		newRow: [ :row | row add: #menuModel ];
		yourself
]

{ #category : #adding }
OPToolbar >> addItem: aLabel [
	| item |
	item := MenuItemModel new.
	item name: aLabel.
	groupModel addMenuItem: item.
	^ item
]

{ #category : #initialization }
OPToolbar >> initializePresenter [
	menuModel applyTo: self
]

{ #category : #initialization }
OPToolbar >> initializeWidgets [
	menuModel := self instantiate: MenuModel.
	groupModel := MenuGroupModel new.
	menuModel addMenuGroup: groupModel
]

{ #category : #accessing }
OPToolbar >> menuModel [
	^ menuModel
]
