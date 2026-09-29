"
Developer-oriented context menu command that opens a Pharo inspector on the active OPViewModelRegistry for the current project context.
"
Class {
	#name : 'OPInspectViewModelRegistryCommand',
	#superclass : 'OPRoassalShapeDevCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'testing' }
OPInspectViewModelRegistryCommand class >> canBeExecutedInContext: aToolContext [

	^ (super canBeExecutedInContext: aToolContext) and: [
			  aToolContext controllers allSatisfy: [ :each |
				  each isKindOf: OPDiagramController ] ]
]

{ #category : 'accessing' }
OPInspectViewModelRegistryCommand >> defaultMenuIconName [

	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectViewModelRegistryCommand >> defaultMenuItemName [

	^ 'Inspect view model registry'
]

{ #category : 'execution' }
OPInspectViewModelRegistryCommand >> execute [

	self diagramController viewModelRegistry inspect
]
