"
Maintains visual styling rules mapped to metamodel element types and stereotype names for diagrams. Coordinates with diagram elements during cascading style property resolution.
"
Class {
	#name : 'OPStyleSheet',
	#superclass : 'Object',
	#instVars : [
		'rules'
	],
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'accessing' }
OPStyleSheet >> atType: aTypeName set: aPropertySymbol to: aValue [
	(self ruleForType: aTypeName) at: aPropertySymbol asSymbol put: aValue
]

{ #category : 'private' }
OPStyleSheet >> cleanTypeName: aTypeName [
	| str |
	str := aTypeName asString trimBoth.
	(str size >= 2 and: [ (str beginsWith: '«') and: [ str endsWith: '»' ] ])
		ifTrue: [ ^ (str copyFrom: 2 to: str size - 1) trimBoth ].
	^ str
]

{ #category : 'initialization' }
OPStyleSheet >> initialize [
	super initialize.
	rules := Dictionary new
]

{ #category : 'copying' }
OPStyleSheet >> postCopy [
	super postCopy.
	rules := rules collect: [ :eachRuleDict | eachRuleDict copy ]
]

{ #category : 'accessing' }
OPStyleSheet >> propertyNamed: aPropertySymbol forElement: aDiagramElement ifAbsent: anAbsentBlock [
	^ self
		propertyNamed: aPropertySymbol
		forElement: aDiagramElement
		ifPresent: [ :val | val ]
		ifAbsent: anAbsentBlock
]

{ #category : 'accessing' }
OPStyleSheet >> propertyNamed: aPropertySymbol forElement: aDiagramElement ifPresent: aPresentBlock [
	^ self
		propertyNamed: aPropertySymbol
		forElement: aDiagramElement
		ifPresent: aPresentBlock
		ifAbsent: [ nil ]
]

{ #category : 'accessing' }
OPStyleSheet >> propertyNamed: aPropertySymbol forElement: aDiagramElement ifPresent: aPresentBlock ifAbsent: anAbsentBlock [
	| propSymbol |
	propSymbol := aPropertySymbol asSymbol.
	aDiagramElement styleTypeNames do: [ :eachTypeName |
		rules at: (self cleanTypeName: eachTypeName) ifPresent: [ :typeRules |
			typeRules at: propSymbol ifPresent: [ :val | ^ aPresentBlock value: val ] ] ].
	^ anAbsentBlock value
]

{ #category : 'accessing' }
OPStyleSheet >> ruleForType: aTypeName [
	^ rules at: (self cleanTypeName: aTypeName) ifAbsentPut: [ Dictionary new ]
]

{ #category : 'accessing' }
OPStyleSheet >> rules [
	^ rules
]
