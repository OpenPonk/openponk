Class {
	#name : #OPOpenPonkShapeStyleTest,
	#superclass : #TestCase,
	#instVars : [
		'style'
	],
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #running }
OPOpenPonkShapeStyleTest >> setUp [

	super setUp.
	style := OPOpenPonkShapeStyle new
]

{ #category : #hooks }
OPOpenPonkShapeStyleTest >> shapeClass [
	^ OPOpenPonkShapeStyle
]

{ #category : #tests }
OPOpenPonkShapeStyleTest >> testLocalStyleNotInherited [
	| a b |
	a := OPShape new.
	(b := OPShape new) owningElement: a.
	self assert: a localStyle equals: nil.
	self assert: b localStyle equals: nil.
	a localStyle: style.
	self assert: a localStyle equals: style.
	self assert: b localStyle equals: nil
]

{ #category : #tests }
OPOpenPonkShapeStyleTest >> testPropertyInheritance [

	| a b aStyle bShared bLocal |
	a := OPShape new.
	(b := OPShape new) owningElement: a.
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

{ #category : #tests }
OPOpenPonkShapeStyleTest >> testSharedStyleIsInherited [

	| a b |
	a := OPShape new.
	(b := OPShape new) owningElement: a.
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

{ #category : #tests }
OPOpenPonkShapeStyleTest >> testSharedStyleOverriden [

	| a b newStyle |
	a := OPShape new.
	(b := OPShape new) owningElement: a.
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
