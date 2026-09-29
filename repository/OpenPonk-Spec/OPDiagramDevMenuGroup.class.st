"
A Commander 1 menu group that clusters internal debugging and inspection commands for developer diagnostics.
"
Class {
	#name : 'OPDiagramDevMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPDiagramDevMenuGroup >> isInlined [
	"Answers true to inline dev items directly into the parent menu."
	^ true
]

{ #category : 'accessing' }
OPDiagramDevMenuGroup >> name [
	"Answers the display name of the menu group."
	^ 'Dev'
]

{ #category : 'accessing' }
OPDiagramDevMenuGroup >> order [
	"Answers the order priority within the parent menu."
	^ 400
]
