"
UI command used to handle the initial setup or placement of a newly created element within a diagram or model.
"
Class {
	#name : 'OPInitialSetElementCommand',
	#superclass : 'OPUICommand',
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'execute' }
OPInitialSetElementCommand >> execute [

	controller creationUICommandClass executeOn: controller
]
