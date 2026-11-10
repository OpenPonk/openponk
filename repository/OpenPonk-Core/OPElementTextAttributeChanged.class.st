"
Announcement signaling that a specific text attribute of an element has been changed. 
Carries the name of the modified attribute.
"
Class {
	#name : 'OPElementTextAttributeChanged',
	#superclass : 'Announcement',
	#instVars : [
		'attributeName'
	],
	#category : 'OpenPonk-Core-UICommands',
	#package : 'OpenPonk-Core',
	#tag : 'UICommands'
}

{ #category : 'initialization' }
OPElementTextAttributeChanged >> initialize [
	attributeName := ''
]
