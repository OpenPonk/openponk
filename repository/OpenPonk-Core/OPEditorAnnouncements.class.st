"
Base class for announcements related to the lifecycle of an editor in OpenPonk. 
Events are typically dispatched on the Workbench's announcer.
"
Class {
	#name : 'OPEditorAnnouncements',
	#superclass : 'Announcement',
	#instVars : [
		'editor'
	],
	#category : 'OpenPonk-Core-Announcements',
	#package : 'OpenPonk-Core',
	#tag : 'Announcements'
}

{ #category : 'instance creation' }
OPEditorAnnouncements class >> on: anEditor [

	^ self new
		  editor: anEditor;
		  yourself
]

{ #category : 'accessing' }
OPEditorAnnouncements >> diagramController [
	^ self editor diagramController
]

{ #category : 'accessing' }
OPEditorAnnouncements >> editor [
	^ editor
]

{ #category : 'accessing' }
OPEditorAnnouncements >> editor: anObject [
	editor := anObject
]
