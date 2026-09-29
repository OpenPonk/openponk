"
A Commander 1 menu group that organizes commands operating on diagram elements and their presentation.
"
Class {
	#name : 'OPDiagramElementsMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPDiagramElementsMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPDiagramElementsMenuGroup >> name [
	^ 'Elements'
]

{ #category : 'accessing' }
OPDiagramElementsMenuGroup >> order [
	^ 10
]
