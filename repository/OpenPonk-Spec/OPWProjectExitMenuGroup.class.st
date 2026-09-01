"
Commander menu group that organizes commands related to closing or exiting the current project and workbench.
"
Class {
	#name : 'OPWProjectExitMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPWProjectExitMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPWProjectExitMenuGroup >> order [
	^ 100
]
