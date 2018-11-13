"
I contain commands related to the entire opened project.
"
Class {
	#name : #OPWProjectSaveMenuGroup,
	#superclass : #CmdMenuGroup,
	#category : #'OpenPonk-Spec-Commands'
}

{ #category : #accessing }
OPWProjectSaveMenuGroup >> isInlined [
	^ true
]

{ #category : #accessing }
OPWProjectSaveMenuGroup >> order [
	^ 10
]
