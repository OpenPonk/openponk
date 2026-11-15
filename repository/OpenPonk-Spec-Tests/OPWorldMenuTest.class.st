"
Verifies OpenPonk system entry points and action registrations in the Pharo World menu.
"
Class {
	#name : 'OPWorldMenuTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'tests' }
OPWorldMenuTest >> testOpenPonkIsDirectActionLeafItem [

	| builder openPonkItem |
	self
		assert: (OPProjectBrowser class >> #menuCommandOn: hasPragmaNamed: #worldMenu)
		description: 'OPProjectBrowser class>>#menuCommandOn: must be annotated with <worldMenu>'.

	builder := PragmaMenuBuilder new.
	OPProjectBrowser menuCommandOn: builder.

	openPonkItem := builder itemNamed: #OpenPonk.
	self assert: openPonkItem class identicalTo: MenuRegistration.
	self assert: openPonkItem name equals: #OpenPonk.
	self assert: openPonkItem parentName identicalTo: nil.
	self assert: openPonkItem spec label equals: 'OpenPonk'.
	self assert: openPonkItem spec action class identicalTo: MessageSend.
	self assert: openPonkItem spec subMenu identicalTo: nil.
	self assertEmpty: (openPonkItem itemList ifNil: [ #(  ) ])
]
