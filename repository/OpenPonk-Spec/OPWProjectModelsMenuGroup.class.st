"
Commander menu group that organizes commands related to managing domain models within the current project, such as creating or merging models.
"
Class {
	#name : 'OPWProjectModelsMenuGroup',
	#superclass : 'CmdMenuGroup',
	#category : 'OpenPonk-Spec-Commands-Workbench',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-Workbench'
}

{ #category : 'testing' }
OPWProjectModelsMenuGroup >> isInlined [
	^ true
]

{ #category : 'accessing' }
OPWProjectModelsMenuGroup >> order [
	^ 30
]
