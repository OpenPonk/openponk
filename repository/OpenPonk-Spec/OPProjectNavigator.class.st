"
I am a tree view of a project.

To define model-specific mappings subclass OPNavigatorAdapter.
"
Class {
	#name : 'OPProjectNavigator',
	#superclass : 'OPModelTreeWidget',
	#category : 'OpenPonk-Spec-Windows',
	#package : 'OpenPonk-Spec',
	#tag : 'Windows'
}

{ #category : 'initialization' }
OPProjectNavigator class >> title [
	^ 'Project Tree'
]

{ #category : 'accessing' }
OPProjectNavigator >> openOn: aProject [

	project := aProject.
	project unsubscribe: self.
	self whenWindowClosedUnsubscribeFrom: project.
	project weakWhenChangedSend: #refresh to: self.
	self refresh
]
