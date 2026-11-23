"
Abstract base class for events detailing structural changes to a model's hierarchy, specifically dealing with the addition or removal of child elements.
"
Class {
	#name : 'OPModelChildrenChangedEvent',
	#superclass : 'OPModelChanged',
	#instVars : [
		'child'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPModelChildrenChangedEvent class >> model: aModel child: aChildElement [

	^ (self model: aModel)
		  child: aChildElement;
		  yourself
]

{ #category : 'accessing' }
OPModelChildrenChangedEvent >> child [

	^ child
]

{ #category : 'accessing' }
OPModelChildrenChangedEvent >> child: aChildElement [

	child := aChildElement
]
