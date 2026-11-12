Class {
	#name : 'OPIconsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Icons',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Icons'
}

{ #category : 'running' }
OPIconsTest >> tearDown [
	OPIcons resetIcons.
	super tearDown
]

{ #category : 'tests' }
OPIconsTest >> testAllCoreAndIdeaIconsDecodeToValidForms [
	| iconClasses |
	iconClasses := {
		OPCoreIcons.
		OPIdeaActionsIcons.
		OPIdeaGraphIcons.
		OPIdeaWelcomeIcons }.
	iconClasses do: [ :iconClass |
		| selectors |
		selectors := iconClass iconSelectors.
		self denyEmpty: selectors.
		selectors do: [ :sel |
			| form |
			form := iconClass perform: sel.
			self
				assert: form isForm
				description: iconClass name , '>>#' , sel asString , ' must return a Form'.
			self
				assert: form width > 0
				description: iconClass name , '>>#' , sel asString , ' must have positive width'.
			self
				assert: form height > 0
				description: iconClass name , '>>#' , sel asString , ' must have positive height' ] ]
]

{ #category : 'tests' }
OPIconsTest >> testOPIconsLookupAndResetAndInspection [
	| found missing presenter |
	OPIcons resetIcons.
	found := OPCoreIcons at: #openponkIcon ifPresent: [ :entry | entry ].
	self
		assert: found isNotNil
		description: 'at:ifPresent: should evaluate block with cached entry'.
	missing := OPCoreIcons at: #openponkIcon ifAbsent: [ nil ].
	self assert: missing identicalTo: found.
	self
		assert: OPIcons resetIcons isNil
		description: 'resetIcons should clear the Icons dictionary and return nil'.
	presenter := OPCoreIcons inspectionIcons: SpPresenter new.
	self
		assert: presenter items size
		equals: OPCoreIcons iconSelectors size
]
