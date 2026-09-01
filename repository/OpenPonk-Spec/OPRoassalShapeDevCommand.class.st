"
Abstract base class for developer-oriented context menu commands, exposing debugging, inspection, and internal diagnostic actions for Roassal shapes.
"
Class {
	#name : 'OPRoassalShapeDevCommand',
	#superclass : 'OPRoassalShapeCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
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
