"
Verifies Roassal shape context menu commands, shortcut activations, inspection commands, and abstract hooks.
"
Class {
	#name : 'OPRoassalShapeCommandsTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Commands-RoassalShape',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'tests' }
OPRoassalShapeCommandsTest >> testActivationsAbstractFlagsAndContextCanvas [

	| canvasPresenterStub testCanvas context |
	self assert: OPRoassalShapeCommand contextMenuActivation class identicalTo: CmdContextMenuActivation.
	self assert: OPRoassalShapeDevCommand contextMenuActivation class identicalTo: CmdContextMenuActivation.
	self assert: OPRoassalShapeDevCommand isAbstract description: 'OPRoassalShapeDevCommand must be abstract'.
	self assert: OPInspectDevCommand isAbstract description: 'OPInspectDevCommand must be abstract'.
	self deny: OPInspectControllerOfRoassalShapeCommand isAbstract description: 'Concrete inspect dev command must not be abstract'.
	self assert: OPToggleRoassalShapeCommand contextMenuActivation class identicalTo: CmdContextMenuActivation.
	self should: [ OPToggleRoassalShapeCommand new basicExecute ] raise: SubclassResponsibility.
	self assert: OPHideRoassalShapeCommand canvasShortcutActivation keyCombination equals: $h meta.
	self assert: OPInspectControllerOfRoassalShapeCommand canvasShortcutActivation keyCombination equals: $i shift meta.
	self assert: OPInspectModelOfRoassalShapeCommand canvasShortcutActivation keyCombination equals: $i meta.

	testCanvas := RSCanvas new.
	canvasPresenterStub := Mock new.
	canvasPresenterStub stub canvas willReturn: testCanvas.
	context := OPRoassalShapeContext for: canvasPresenterStub.
	self assert: context canvas identicalTo: testCanvas
]

{ #category : 'tests' }
OPRoassalShapeCommandsTest >> testInspectCommandsExecuteSingleAndMultipleItems [

	| existingWindows diagramControllerStub singleItem registryStub contextStub controllerCommand modelCommand registryCommand multiContext |
	existingWindows := (self currentWorld submorphs select: [ :each | each isSystemWindow ]) asIdentitySet.
	singleItem := Mock new.
	singleItem stub inspect willReturn: singleItem.
	registryStub := Mock new.
	registryStub stub inspect willReturn: registryStub.
	diagramControllerStub := Mock new.
	diagramControllerStub stub canvas willReturn: nil.
	diagramControllerStub stub viewModelRegistry willReturn: registryStub.

	contextStub := Mock new.
	contextStub stub diagramController willReturn: diagramControllerStub.
	contextStub stub roassalShapes willReturn: #(  ).
	contextStub stub controllers willReturn: { singleItem }.
	contextStub stub diagramElements willReturn: #(  ).
	contextStub stub viewModels willReturn: #(  ).
	contextStub stub models willReturn: { singleItem }.

	controllerCommand := OPInspectControllerOfRoassalShapeCommand new.
	controllerCommand readParametersFromContext: contextStub.
	controllerCommand execute.
	singleItem should receive inspect.

	modelCommand := OPInspectModelOfRoassalShapeCommand new.
	modelCommand readParametersFromContext: contextStub.
	modelCommand execute.
	singleItem should receive inspect twice.

	registryCommand := OPInspectViewModelRegistryCommand new.
	registryCommand readParametersFromContext: contextStub.
	registryCommand execute.
	registryStub should receive inspect.

	multiContext := Mock new.
	multiContext stub diagramController willReturn: diagramControllerStub.
	multiContext stub roassalShapes willReturn: #(  ).
	multiContext stub controllers willReturn: {
			Object new.
			Object new }.
	multiContext stub diagramElements willReturn: #(  ).
	multiContext stub viewModels willReturn: #(  ).
	multiContext stub models willReturn: {
			Object new.
			Object new }.

	[
		controllerCommand readParametersFromContext: multiContext.
		controllerCommand execute.
		modelCommand readParametersFromContext: multiContext.
		modelCommand execute ] ensure: [
			self currentWorld submorphs do: [ :each |
				(each isSystemWindow and: [ (existingWindows includes: each) not ]) ifTrue: [ each delete ] ] ]
]

{ #category : 'tests' }
OPRoassalShapeCommandsTest >> testInspectDevCommandAbstractHooksDefaultNameAndItems [

	| diagramControllerStub contextStub controller element shape controllerCommand elementCommand shapeCommand |
	self should: [ OPInspectDevCommand new itemType ] raise: SubclassResponsibility.
	self should: [ OPInspectDevCommand new items ] raise: SubclassResponsibility.
	self assert: OPInspectControllerOfRoassalShapeCommand new defaultMenuItemName equals: 'Inspect controller'.
	self assert: OPInspectModelOfRoassalShapeCommand new defaultMenuItemName equals: 'Inspect model'.
	self assert: OPInspectViewModelRegistryCommand new defaultMenuIconName equals: #glamorousInspect.

	controller := Object new.
	element := Object new.
	shape := Object new.
	diagramControllerStub := Mock new.
	diagramControllerStub stub canvas willReturn: nil.
	contextStub := Mock new.
	contextStub stub diagramController willReturn: diagramControllerStub.
	contextStub stub roassalShapes willReturn: { shape }.
	contextStub stub controllers willReturn: { controller }.
	contextStub stub diagramElements willReturn: { element }.
	contextStub stub viewModels willReturn: #(  ).
	contextStub stub models willReturn: #(  ).

	controllerCommand := OPInspectControllerOfRoassalShapeCommand new.
	controllerCommand readParametersFromContext: contextStub.
	self assertCollection: controllerCommand items hasSameElements: { controller }.

	elementCommand := OPInspectDiagramElementCommand new.
	elementCommand readParametersFromContext: contextStub.
	self assertCollection: elementCommand items hasSameElements: { element }.

	shapeCommand := OPInspectRoassalShapeCommand new.
	shapeCommand readParametersFromContext: contextStub.
	self assertCollection: shapeCommand items hasSameElements: { shape }
]
