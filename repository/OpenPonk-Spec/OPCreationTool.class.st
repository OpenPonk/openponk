"
Abstract palette tool designed for creating new diagram nodes/entities/edges on the canvas.
Manages the mouse interaction and placement of the new element.
"
Class {
	#name : 'OPCreationTool',
	#superclass : 'OPPaletteTool',
	#instVars : [
		'factory',
		'controller',
		'feedback',
		'onComplete'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPCreationTool >> deselect [

	feedback value: nil
]

{ #category : 'actions' }
OPCreationTool >> doOnCompleteActions [

	onComplete value: controller.
	controller diagramController ifNotNil: [ :activeDiagramCtrl | activeDiagramCtrl form ifNotNil: [ :form | form focusFirstInput ] ]
]

{ #category : 'accessing' }
OPCreationTool >> factory: aBlock [

	factory := aBlock
]

{ #category : 'initialization' }
OPCreationTool >> initialize [

	super initialize.
	onComplete := [ :newController | "do nothing" ]
]

{ #category : 'callbacks' }
OPCreationTool >> whenCreated: aOneArgBlock [

	onComplete := aOneArgBlock
]
