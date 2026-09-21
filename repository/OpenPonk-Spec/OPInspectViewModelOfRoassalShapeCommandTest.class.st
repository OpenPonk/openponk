Class {
	#name : 'OPInspectViewModelOfRoassalShapeCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'command',
		'fakeContext',
		'fakeViewModel'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPInspectViewModelOfRoassalShapeCommandTest >> setUp [
	| fakeDiagramController |
	super setUp.
	fakeViewModel := Object new.
	fakeDiagramController := Mock new.
	fakeDiagramController stub canvas willReturn: nil.
	fakeContext := Mock new.
	fakeContext stub diagramController willReturn: fakeDiagramController.
	fakeContext stub roassalShapes willReturn: #().
	fakeContext stub controllers willReturn: { Mock new }.
	fakeContext stub diagramElements willReturn: #().
	fakeContext stub viewModels willReturn: { fakeViewModel }.
	fakeContext stub models willReturn: #()
]

{ #category : 'tests' }
OPInspectViewModelOfRoassalShapeCommandTest >> testDefaultMenuItemNamePlural [
	| multiContext fakeDiagramController |
	fakeDiagramController := Mock new.
	fakeDiagramController stub canvas willReturn: nil.
	multiContext := Mock new.
	multiContext stub diagramController willReturn: fakeDiagramController.
	multiContext stub roassalShapes willReturn: #().
	multiContext stub controllers willReturn: { Mock new . Mock new }.
	multiContext stub diagramElements willReturn: #().
	multiContext stub viewModels willReturn: { fakeViewModel . Object new }.
	multiContext stub models willReturn: #().

	command := OPInspectViewModelOfRoassalShapeCommand new.
	command readParametersFromContext: multiContext.
	self assert: command defaultMenuItemName equals: 'Inspect view models'
]

{ #category : 'tests' }
OPInspectViewModelOfRoassalShapeCommandTest >> testDefaultMenuItemNameSingular [
	command := OPInspectViewModelOfRoassalShapeCommand new.
	command readParametersFromContext: fakeContext.
	self assert: command defaultMenuItemName equals: 'Inspect view model'
]

{ #category : 'tests' }
OPInspectViewModelOfRoassalShapeCommandTest >> testItemType [
	command := OPInspectViewModelOfRoassalShapeCommand new.
	self assert: command itemType equals: 'view model'
]

{ #category : 'tests' }
OPInspectViewModelOfRoassalShapeCommandTest >> testReadParametersAndItems [
	command := OPInspectViewModelOfRoassalShapeCommand new.
	command readParametersFromContext: fakeContext.
	self assertCollection: command items hasSameElements: { fakeViewModel }
]
