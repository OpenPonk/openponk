Class {
	#name : #OPDIOpenPonkStyleTest,
	#superclass : #OPDiagramElementTestCase,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #accessing }
OPDIOpenPonkStyleTest >> elementClass [
	^ OPDIOpenPonkStyle
]

{ #category : #accessing }
OPDIOpenPonkStyleTest >> testLocalStyleNotInherited [
	| a b |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	self assert: a localStyle equals: nil.
	self assert: b localStyle equals: nil.
	a localStyle: element.
	self assert: a localStyle equals: element.
	self assert: b localStyle equals: nil
]

{ #category : #accessing }
OPDIOpenPonkStyleTest >> testPropertyInheritance [

	| a b aStyle bShared bLocal |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	(aStyle := OPDIOpenPonkStyle new) fontSize: 15.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	a sharedStyle: aStyle.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 15.
	bShared := OPDIOpenPonkStyle new.
	b sharedStyle: bShared.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 15.
	bShared fontSize: 20.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 20.
	bLocal := OPDIOpenPonkStyle new.
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

{ #category : #accessing }
OPDIOpenPonkStyleTest >> testSharedStyleIsInherited [

	| a b |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	element fontSize: 5.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 1.
	a sharedStyle: element.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5
]

{ #category : #accessing }
OPDIOpenPonkStyleTest >> testSharedStyleOverriden [

	| a b newStyle |
	a := OPDiagramElement new.
	(b := OPDiagramElement new) owningElement: a.
	element fontSize: 5.
	a sharedStyle: element.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	newStyle := self elementClass new.
	newStyle fontSize: 10.
	b localStyle: newStyle.
	self
		assert: (a stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 5.
	self
		assert: (b stylePropertyNamed: #fontSize ifAbsent: [ 1 ])
		equals: 10
]
