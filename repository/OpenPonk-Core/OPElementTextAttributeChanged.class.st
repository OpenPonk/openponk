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

{ #category : 'instance creation' }
OPElementTextAttributeChanged class >> withAttributeName: aString [
	^ self new
		attributeName: aString;
		yourself
]

{ #category : 'accessing' }
OPElementTextAttributeChanged >> attributeName: aString [
	attributeName := aString
]

{ #category : 'initialization' }
OPElementTextAttributeChanged >> initialize [
	attributeName := ''
]
