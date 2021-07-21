Class {
	#name : #OPDiagramToolbarBasicMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #testing }
OPDiagramToolbarBasicMenuGroup >> isInlined [
	^ true
]

{ #category : #accessing }
OPDiagramToolbarBasicMenuGroup >> name [
	^ 'Basic actions'
]

{ #category : #accessing }
OPDiagramToolbarBasicMenuGroup >> order [
	^ 1
]
