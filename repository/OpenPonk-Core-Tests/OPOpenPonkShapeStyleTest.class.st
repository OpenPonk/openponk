"
Unit tests for OPOpenPonkShapeStyle. 
Verifies property assignment, inheritance, and overriding behavior for both local and shared shape styles.
"
Class {
	#name : 'OPOpenPonkShapeStyleTest',
	#superclass : 'TestCase',
	#instVars : [
		'style'
	],
	#category : 'OpenPonk-Core-Tests-DiagramElements',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'DiagramElements'
}

{ #category : 'running' }
OPOpenPonkShapeStyleTest >> setUp [

	super setUp.
	style := OPOpenPonkShapeStyle new
]

{ #category : 'hooks' }
OPOpenPonkShapeStyleTest >> shapeClass [
	^ OPOpenPonkShapeStyle
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testAddedAsSharedToStyledElementSignalsErrorWhenNotAssignedAsSharedStyle [
	| diagramElement orphanStyle |
	diagramElement := OPDiagramOnlyShape new.
	orphanStyle := OPOpenPonkShapeStyle new.
	self
		should: [ orphanStyle addedAsSharedToStyledElement: diagramElement ]
		raise: Error
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testAllStylePropertyAccessors [
	style fillColor: Color red.
	style fillOpacity: 0.75.
	style fontBold: true.
	style fontColor: Color blue.
	style fontItalic: true.
	style fontName: 'Source Sans Pro'.
	style fontSize: 14.
	style fontStrikeThrough: true.
	style fontUnderline: true.
	style strokeColor: Color green.
	style strokeDashLength: #( 4 2 ).
	style strokeOpacity: 0.5.
	style strokeWidth: 2.

	self assert: style fillColor equals: Color red.
	self assert: style fillOpacity equals: 0.75.
	self assert: style fontBold description: 'fontBold should be true'.
	self assert: style fontColor equals: Color blue.
	self assert: style fontItalic description: 'fontItalic should be true'.
	self assert: style fontName equals: 'Source Sans Pro'.
	self assert: style fontSize equals: 14.
	self assert: style fontStrikeThrough description: 'fontStrikeThrough should be true'.
	self assert: style fontUnderline description: 'fontUnderline should be true'.
	self assert: style strokeColor equals: Color green.
	self assert: style strokeDashLength equals: #( 4 2 ).
	self assert: style strokeOpacity equals: 0.5.
	self assert: style strokeWidth equals: 2
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testLocalStyleNotInherited [
	| a b |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	self assert: a localStyle equals: nil.
	self assert: b localStyle equals: nil.
	a localStyle: style.
	self assert: a localStyle equals: style.
	self assert: b localStyle equals: nil
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testPropertyInheritance [

	| a b aStyle bShared bLocal |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	(aStyle := OPOpenPonkShapeStyle new) fontSize: 15.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	a sharedStyle: aStyle.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 15.
	bShared := OPOpenPonkShapeStyle new.
	b sharedStyle: bShared.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 15.
	bShared fontSize: 20.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 20.
	bLocal := OPOpenPonkShapeStyle new.
	b localStyle: bLocal.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 20.
	bLocal fontSize: 25.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 25.
	bLocal removeKey: #fontSize.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 20.
	bShared removeKey: #fontSize.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 15
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testSharedStyleIsInherited [

	| a b |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	style fontSize: 5.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	a sharedStyle: style.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5
]

{ #category : 'tests' }
OPOpenPonkShapeStyleTest >> testSharedStyleOverriden [

	| a b newStyle |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	style fontSize: 5.
	a sharedStyle: style.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	newStyle := self shapeClass new.
	newStyle fontSize: 10.
	b localStyle: newStyle.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 10
]
