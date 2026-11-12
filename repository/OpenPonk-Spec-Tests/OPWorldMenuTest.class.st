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
	self
		assert: openPonkItem isNotNil
		description: 'World menu builder should contain an item named #OpenPonk'.
	self
		assert: openPonkItem parentName isNil
		description: 'OpenPonk menu item should be a top-level root item'.
	self
		assert: openPonkItem spec action isNotNil
		description: 'OpenPonk menu item must have a direct action block'.
	self
		assert: openPonkItem spec subMenu isNil
		description: 'OpenPonk menu item must not have a submenu'.
	self assertEmpty: (openPonkItem itemList ifNil: [ #(  ) ])
]
