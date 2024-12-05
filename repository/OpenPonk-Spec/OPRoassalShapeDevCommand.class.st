Class {
	#name : 'OPRoassalShapeDevCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'testing' }
OPRoassalShapeDevCommand class >> canBeExecutedInContext: aToolContext [
	^ OPWorkbench isDevelopmentMode
]

{ #category : 'activation' }
OPRoassalShapeDevCommand class >> contextMenuActivation [
	<classAnnotation>
	^ CmdContextMenuActivation byItemOf: OPRoassalShapeDevMenuGroup for: OPCanvasPresenter
]

{ #category : 'testing' }
OPRoassalShapeDevCommand class >> isAbstract [
	^ self = OPRoassalShapeDevCommand
]
