"
Menu builder for DCNavigator.
"
Class {
	#name : #OPMenuBuilder,
	#superclass : #Object,
	#instVars : [
		'menu'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #adding }
OPMenuBuilder >> addItem: aName action: aBlock [
	self group
		addItem: [ :item | 
			item
				name: aName;
				action: aBlock ]
]

{ #category : #adding }
OPMenuBuilder >> addItem: aName icon: anIcon action: aBlock [
	self group
		addItem: [ :item | 
			item
				name: aName;
				icon: anIcon;
				action: aBlock ]
]

{ #category : #adding }
OPMenuBuilder >> addItem: aName icon: anIcon subMenu: aMenu [
	self group
		addItem: [ :item | 
			item
				name: aName;
				icon: anIcon;
				subMenu: aMenu ]
]

{ #category : #adding }
OPMenuBuilder >> addItem: aName subMenu: aMenu [
	self group
		addItem: [ :item | 
			item
				name: aName;
				subMenu: aMenu ]
]

{ #category : #accessing }
OPMenuBuilder >> group [
	^ menu menuGroups
		ifEmpty: [ menu addGroup: [ :group |  ] ];
		first
]

{ #category : #initialization }
OPMenuBuilder >> initialize [
	super initialize.
	menu := MenuModel new
]

{ #category : #accessing }
OPMenuBuilder >> menu [
	^ menu
]

{ #category : #accessing }
OPMenuBuilder >> menu: aMenu [
	menu := aMenu
]
