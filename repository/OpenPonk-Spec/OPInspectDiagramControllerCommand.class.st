"
A developer diagnostic command that opens a system inspector on the active diagram controller.
"
Class {
	#name : 'OPInspectDiagramControllerCommand',
	#superclass : 'OPDiagramCanvasCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPInspectDiagramControllerCommand class >> diagramMenuActivation [
	<classAnnotation>
	^ OPDiagramMenuActivation
		byItemOf: OPDiagramDevMenuGroup
		order: 10
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPInspectDiagramControllerCommand >> defaultMenuIconName [
	"Answers the icon name for inspecting the controller."
	^ #glamorousInspect
]

{ #category : 'accessing' }
OPInspectDiagramControllerCommand >> defaultMenuItemName [
	"Answers the label for inspecting the active diagram controller."
	^ 'Inspect Controller...'
]

{ #category : 'execution' }
OPInspectDiagramControllerCommand >> execute [
	"Opens an inspector on the active diagram controller."
	diagramPresenter diagramController inspect
]
