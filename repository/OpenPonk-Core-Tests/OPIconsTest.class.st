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

	| found cached missing reloaded presenter firstItem scaledForm selectorName |
	OPIcons resetIcons.
	found := OPCoreIcons at: #openponkIcon ifPresent: [ :entry | entry ].
	self assert: found isForm description: 'OPIcons lookup must return a Form'.
	cached := OPCoreIcons at: #openponkIcon ifAbsent: [ nil ].
	self assert: cached identicalTo: found.
	missing := OPCoreIcons at: #nonExistentIconSelector ifAbsent: [ #missing ].
	self assert: missing equals: #missing.
	self assert: (OPCoreIcons at: #nonExistentIconSelector ifPresent: [ :entry | entry ]) identicalTo: nil.
	self assert: OPIcons resetIcons identicalTo: nil.
	reloaded := OPCoreIcons at: #openponkIcon ifAbsent: [ nil ].
	self assert: reloaded isForm description: 'Reloaded icon after resetIcons must be a Form'.
	self deny: reloaded identicalTo: found.
	self
		assertCollection: OPCoreIcons iconSelectors
		includesAll: #( #opDiagramIcon #opHideLabelsIcon #opHideSomeLabelsIcon #opShowLabelsIcon ).
	presenter := OPCoreIcons inspectionIcons: SpPresenter new.
	self assert: presenter items size equals: OPCoreIcons iconSelectors size.
	firstItem := presenter items first.
	scaledForm := presenter columns first evaluation value: firstItem.
	selectorName := presenter columns second evaluation value: firstItem.
	self assert: scaledForm isForm description: 'Inspector icon column must evaluate to a Form'.
	self assert: selectorName isSymbol description: 'Inspector name column must evaluate to a selector symbol'
]
