"
I am fired by RenameElementCommand after a model element has been renamed.
"
Class {
	#name : 'OPElementRenamed',
	#superclass : 'OPElementTextAttributeChanged',
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'initialization' }
OPElementRenamed >> initialize [
	super initialize.
	attributeName := 'Name'
]
