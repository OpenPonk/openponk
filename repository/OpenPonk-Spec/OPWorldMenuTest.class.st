Class {
	#name : 'OPWorldMenuTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPWorldMenuTest >> testNotationMenusAreCompletelyRemovedFromWorldMenu [
	| builder notationIdentifiers |
	builder := PragmaMenuBuilder pragmaKeyword: 'worldMenu' model: nil.
	builder buildTree.

	notationIdentifiers := #( #UMLClassEditor #BPMNEditor #BORMEditor #OPDEMO #OPERD #OPFSM #OPMC #OntoUML #'Petri Nets' #OpenPonkProjectBrowser ).
	notationIdentifiers do: [ :eachIdentifier | 
		self assert: (builder itemNamed: eachIdentifier) isNil ]
]

{ #category : 'tests' }
OPWorldMenuTest >> testOpenPonkIsDirectActionLeafItem [
	| builder openPonkItem |
	builder := PragmaMenuBuilder pragmaKeyword: 'worldMenu' model: nil.
	builder buildTree.

	openPonkItem := builder itemNamed: #OpenPonk.
	self assert: openPonkItem isNotNil.
	self assert: openPonkItem parentName isNil.
	self assert: openPonkItem owner equals: builder.
	self assert: openPonkItem spec action isNotNil.
	self assert: openPonkItem spec subMenu isNil.
	self assert: (openPonkItem itemList ifNil: [ #() ]) isEmpty
]
