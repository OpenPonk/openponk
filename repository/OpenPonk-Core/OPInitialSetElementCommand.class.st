Class {
	#name : #OPInitialSetElementCommand,
	#superclass : #OPUICommand,
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #execute }
OPInitialSetElementCommand >> execute [

	OPNavigatorAdapters default initialSetupFor: element in: model
]
