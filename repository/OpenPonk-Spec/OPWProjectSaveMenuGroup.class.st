"
Commander menu group that organizes commands related to persisting the entire opened project, including save and save-as operations.
"
Class {
	#name : 'OPWProjectSaveMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPWProjectSaveMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPWProjectSaveMenuGroup >> order [
	^ 20
]
