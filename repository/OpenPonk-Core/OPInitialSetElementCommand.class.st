Class {
	#name : #OPInitialSetElementCommand,
	#superclass : #OPUICommand,
	#category : #'OpenPonk-Core-UICommands'
}

{ #category : #execute }
OPInitialSetElementCommand >> execute [

	controller diagramController editor workbench projectController
		navigatorAdapters
		initialSetupFor: controller model
		in: controller diagramController
]
