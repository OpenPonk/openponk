"
Commander menu group that dynamically generates color selection commands for context menus based on predefined palettes or current shape styles.
"
Class {
	#name : 'OPRoassalShapeColorMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> colorNameFor: aColor [
	aColor name = #unnamed ifFalse: [
		^ aColor name capitalized splitCamelCase last ].
	^ self customColorNames
		at: aColor asHexString asUppercase
		ifAbsent: [ self error: 'No color name defined for: #' , aColor asHexString ]
]

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> colors [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> commandSuperclass [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPRoassalShapeColorMenuGroup class >> customColorNames [
	^ Dictionary new
		at: 'DCE5EC' put: 'Slate';
		at: 'D6FCEB' put: 'Mint';
		yourself
]

{ #category : 'hooks' }
OPRoassalShapeColorMenuGroup class >> styleAttribute [

	^ self subclassResponsibility
]
