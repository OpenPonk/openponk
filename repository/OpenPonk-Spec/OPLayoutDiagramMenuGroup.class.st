"
I am a menu group for layouts applicable to the current diagram.
"
Class {
	#name : #OPLayoutDiagramMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'OpenPonk-Spec-Layouting'
}

{ #category : #accessing }
OPLayoutDiagramMenuGroup >> icon [
	^ OPIdeaGraphIcons layoutIcon
]

{ #category : #accessing }
OPLayoutDiagramMenuGroup >> name [
	^ 'Layout'
]

{ #category : #accessing }
OPLayoutDiagramMenuGroup >> order [
	^ 200
]
