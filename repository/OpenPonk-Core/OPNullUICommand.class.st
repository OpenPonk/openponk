"
Implements the Null Object pattern for UI commands. 
Execution performs no action, providing a safe default when no command is applicable.
"
Class {
	#name : 'OPNullUICommand',
	#superclass : 'OPUICommand',
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'execute' }
OPNullUICommand >> execute [
	"do nothing"

	
]
