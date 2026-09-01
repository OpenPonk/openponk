"
Commander menu group that organizes commands related to opening existing projects.
"
Class {
	#name : 'OPWProjectOpenMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPWProjectOpenMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPWProjectOpenMenuGroup >> order [
	^ 10
]
