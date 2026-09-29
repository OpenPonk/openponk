"
Announcement fired following the successful renaming of a model element, typically triggered by OPRenameElementCommand.
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
