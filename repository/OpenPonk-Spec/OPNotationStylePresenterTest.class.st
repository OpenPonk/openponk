"
Verifies the lifecycle and editing behavior of the notation style presenter, ensuring rules are loaded from plugins, modified in the style registry, and restored to built-in defaults.
"
Class {
	#name : 'OPNotationStylePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'plugin',
		'presenter'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPNotationStylePresenterTest >> setUp [
	super setUp.
	OPNotationStyleRegistry resetDefault.
	plugin := OPTestPlugin new.
	presenter := OPNotationStylePresenter new
]

{ #category : 'running' }
OPNotationStylePresenterTest >> tearDown [
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
	self assert: (icon isKindOf: Form).
	self assert: icon extent equals: 14 @ 14
]

{ #category : 'tests' }
OPNotationStylePresenterTest >> testItemsLoadedFromPlugin [
	presenter plugin: plugin.
	self deny: presenter items isEmpty.
	self assert: (presenter items anySatisfy: [ :each | each typeName = 'Kind' ])
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
