"
Maintains the presentation state of a single notation style rule, including the metamodel type name, style property symbol, effective visual value, built-in default value, and override status.
"
Class {
	#name : 'OPNotationStyleItem',
	#superclass : 'Object',
	#instVars : [
		'typeName',
		'property',
		'color',
		'defaultColor',
		'isOverridden'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'accessing' }
OPNotationStyleItem >> color [
	^ color
]

{ #category : 'accessing' }
OPNotationStyleItem >> color: aColor [
	color := aColor
]

{ #category : 'accessing' }
OPNotationStyleItem >> defaultColor [
	^ defaultColor
]

{ #category : 'accessing' }
OPNotationStyleItem >> defaultColor: aColor [
	defaultColor := aColor
]

{ #category : 'accessing' }
OPNotationStyleItem >> isOverridden [
	^ isOverridden ifNil: [ false ]
]

{ #category : 'accessing' }
OPNotationStyleItem >> isOverridden: aBoolean [
	isOverridden := aBoolean
]

{ #category : 'accessing' }
OPNotationStyleItem >> property [
	^ property
]

{ #category : 'accessing' }
OPNotationStyleItem >> property: aSymbol [
	property := aSymbol
]

{ #category : 'accessing' }
OPNotationStyleItem >> typeName [
	^ typeName
]

{ #category : 'accessing' }
OPNotationStyleItem >> typeName: aString [
	typeName := aString
]
