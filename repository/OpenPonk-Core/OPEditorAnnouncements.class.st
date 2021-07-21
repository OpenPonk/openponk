"
I am a base class for announcements tied to Editor lifecycle.
All my events are fired on the Workbench's announcer.
"
Class {
	#name : #OPEditorAnnouncements,
	#superclass : #Announcement,
	#instVars : [
		'editor',
		'diagramController'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #'instance creation' }
OPEditorAnnouncements class >> on: anEditor [
	^ self new
		editor: anEditor;
		diagramController: anEditor diagramController
]

{ #category : #accessing }
OPEditorAnnouncements >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPEditorAnnouncements >> diagramController: anObject [
	diagramController := anObject
]

{ #category : #accessing }
OPEditorAnnouncements >> editor [
	^ editor
]

{ #category : #accessing }
OPEditorAnnouncements >> editor: anObject [
	editor := anObject
]
