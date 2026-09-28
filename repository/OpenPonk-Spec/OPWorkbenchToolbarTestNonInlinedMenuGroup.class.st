Class {
	#name : 'OPWorkbenchToolbarTestNonInlinedMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPWorkbenchToolbarTestNonInlinedMenuGroup >> name [
	"Answers the display name of the test menu group."
	^ 'Test Inactive Group'
]

{ #category : 'accessing' }
OPWorkbenchToolbarTestNonInlinedMenuGroup >> order [
	"Answers the sort order."
	^ 100
]
