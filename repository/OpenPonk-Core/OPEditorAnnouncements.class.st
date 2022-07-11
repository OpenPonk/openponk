"
I am a base class for announcements tied to Editor lifecycle.
All my events are fired on the Workbench's announcer.
"
Class {
	#name : #OPEditorAnnouncements,
	#superclass : #Announcement,
	#instVars : [
		'editor'
	],
	#category : #'OpenPonk-Core-Announcements'
}

{ #category : #'instance creation' }
OPEditorAnnouncements class >> on: anEditor [

	^ self new
		  editor: anEditor;
		  yourself
]

{ #category : #accessing }
OPEditorAnnouncements >> diagramController [
	^ self editor diagramController
]

{ #category : #accessing }
OPEditorAnnouncements >> editor [
	^ editor
]

{ #category : #accessing }
OPEditorAnnouncements >> editor: anObject [
	editor := anObject
]
