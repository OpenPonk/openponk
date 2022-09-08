"
I am a tree view of a project.

To define model-specific mappings subclass OPNavigatorAdapter.
"
Class {
	#name : #OPProjectNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #initialization }
OPProjectNavigator class >> title [
	^ 'Project Tree'
]

{ #category : #accessing }
OPProjectNavigator >> openOn: aProject [

	project := aProject.
	project unsubscribe: self.
	project whenChanged: [ self refresh ].
	self refresh.
	self withWindowDo: [ :window | 
		window whenClosedDo: [ project unsubscribe: self ] ]
]
