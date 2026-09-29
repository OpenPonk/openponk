"
A Commander 1 menu group that holds foundational model commands in the main workbench Model menu.
"
Class {
	#name : 'OPModelBasicMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPModelBasicMenuGroup >> isInlined [
	"Answers true to inline items into the parent menu."
	^ true
]

{ #category : 'accessing' }
OPModelBasicMenuGroup >> name [
	"Answers the display name of the group."
	^ 'Model'
]

{ #category : 'accessing' }
OPModelBasicMenuGroup >> order [
	"Answers the order priority of the group."
	^ 10
]
