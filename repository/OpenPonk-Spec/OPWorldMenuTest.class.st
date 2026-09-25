Class {
	#name : 'OPWorldMenuTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPWorldMenuTest >> testOpenPonkIsDirectActionLeafItem [
	| builder openPonkItem |
	self assert: ((OPProjectBrowser class >> #menuCommandOn:) hasPragmaNamed: #worldMenu).

	builder := PragmaMenuBuilder new.
	OPProjectBrowser menuCommandOn: builder.

	openPonkItem := builder itemNamed: #OpenPonk.
	self assert: openPonkItem isNotNil.
	self assert: openPonkItem parentName isNil.
	self assert: openPonkItem spec action isNotNil.
	self assert: openPonkItem spec subMenu isNil.
	self assert: (openPonkItem itemList ifNil: [ #() ]) isEmpty
]
