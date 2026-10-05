"
Maintains user-defined style overrides for notations and plugins, layering user customizations over default notation style sheets.
"
Class {
	#name : 'OPNotationStyleRegistry',
	#superclass : 'Object',
	#instVars : [
		'userRules'
	],
	#classInstVars : [
		'default'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPNotationStyleRegistry class >> default [
	^ default ifNil: [ default := self new ]
]

{ #category : 'initialization' }
OPNotationStyleRegistry class >> resetDefault [
	default := nil
]

{ #category : 'accessing' }
OPNotationStyleRegistry >> atPlugin: aPlugin type: aTypeName set: aPropertySymbol to: aValue [
	| typeRules |
	typeRules := (self rulesForPlugin: aPlugin) at: aTypeName asString ifAbsentPut: [ Dictionary new ].
	typeRules at: aPropertySymbol asSymbol put: aValue
]

{ #category : 'initialization' }
OPNotationStyleRegistry >> initialize [
	super initialize.
	userRules := Dictionary new
]

{ #category : 'accessing' }
OPNotationStyleRegistry >> removeAtPlugin: aPlugin type: aTypeName property: aPropertySymbol [
	| pluginRules |
	pluginRules := userRules at: aPlugin name ifAbsent: [ ^ self ].
	pluginRules at: aTypeName asString ifPresent: [ :typeRules |
		typeRules removeKey: aPropertySymbol asSymbol ifAbsent: [ ].
		typeRules ifEmpty: [ pluginRules removeKey: aTypeName asString ] ]
]

{ #category : 'initialization' }
OPNotationStyleRegistry >> resetForPlugin: aPlugin [
	userRules removeKey: aPlugin name ifAbsent: [ ]
]

{ #category : 'accessing' }
OPNotationStyleRegistry >> rulesForPlugin: aPlugin [
	^ userRules at: aPlugin name ifAbsentPut: [ Dictionary new ]
]
