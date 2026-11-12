"
Verifies the lifecycle and editing behavior of the notation style presenter, ensuring rules are loaded from plugins, modified in the style registry, and restored to built-in defaults.
"
Class {
	#name : 'OPNotationStylePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'plugin',
		'presenter',
		'window'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'running' }
OPNotationStylePresenterTest >> setUp [
	super setUp.
	OPNotationStyleRegistry resetDefault.
	plugin := OPTestPlugin new.
	presenter := OPNotationStylePresenter new.
	window := nil.
]

{ #category : 'running' }
OPNotationStylePresenterTest >> tearDown [

	window ifNotNil: [ window close ].
	window := nil.
	presenter := nil.
	plugin := nil.
	OPNotationStyleRegistry resetDefault.
	super tearDown
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testChangeColorUpdatesItemAndRegistry [
	presenter plugin: plugin.
	presenter changeColorForType: 'Kind' to: Color red.
	self assert: (presenter colorForType: 'Kind') equals: Color red.
	self
		assert: ((OPNotationStyleRegistry default rulesForPlugin: plugin)
			at: 'Kind' ifAbsent: [ Dictionary new ])
		equals: (Dictionary new at: #fillColor put: Color red; yourself)
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testColorIconForReturnsValidForm [
	| icon |
	icon := presenter colorIconFor: Color paleGreen.
	self assert: (icon isKindOf: Form) description: 'colorIconFor: should return a Form instance'.
	self assert: icon extent equals: 14 @ 14
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testItemsLoadedFromPlugin [
	presenter plugin: plugin.
	self denyEmpty: presenter items.
	self
		assert: (presenter items anySatisfy: [ :each | each typeName = 'Kind' ])
		description: 'Loaded items for OPTestPlugin should contain Kind type'
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testKindHasDefaultFillColor [
	presenter plugin: plugin.
	self assert: (presenter colorForType: 'Kind') equals: Color paleGreen
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testResetTypeRestoresDefaultColor [
	presenter plugin: plugin.
	presenter changeColorForType: 'Kind' to: Color red.
	presenter resetType: 'Kind'.
	self assert: (presenter colorForType: 'Kind') equals: Color paleGreen
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testWindowOpeningSelectionResetAndResetAll [

	| kindItem |
	window := OPNotationStylePresenter openForPlugin: plugin.
	presenter := window presenter.
	self assert: window title equals: plugin name , ' - Notation Style Settings'.
	kindItem := presenter itemForType: 'Kind'.
	self assert: kindItem isNotNil description: 'Kind style item should exist'.
	self assert: kindItem property equals: #fillColor.
	self assert: kindItem defaultColor equals: Color paleGreen.
	self deny: kindItem isOverridden description: 'Kind should not be marked overridden initially'.

	presenter changeColorForType: 'Kind' to: Color red.
	self assert: kindItem isOverridden description: 'Kind should be marked overridden after custom color change'.
	self assert: kindItem color equals: Color red.

	presenter treeTable selectItem: kindItem.
	self assert: presenter selectedItem identicalTo: kindItem.
	presenter resetSelectedType.
	self deny: kindItem isOverridden description: 'Kind should no longer be marked overridden after resetSelectedType'.
	self assert: (presenter colorForType: 'Kind') equals: Color paleGreen.

	presenter changeColorForType: 'Kind' to: Color blue.
	self assert: (presenter colorForType: 'Kind') equals: Color blue.
	presenter resetAll.
	self assert: (presenter colorForType: 'Kind') equals: Color paleGreen.
	self assertEmpty: (OPNotationStyleRegistry default rulesForPlugin: plugin)
]
