"
Acts as the ViewModel for an OPProject. 
Serves as the top-level structural bridge between the project root and the graphical interface, providing project-level context for the workbench tree.
"
Class {
	#name : 'OPProjectViewModel',
	#superclass : 'OPViewModel',
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPProjectViewModel class >> modelClass [

	^ OPProject
]

{ #category : 'private' }
OPProjectViewModel >> basicRemoveModel [
	"Specific domain model removal logic - removal from owner, disconnecting from peers, etc."

	"do nothing"
]

{ #category : 'accessing' }
OPProjectViewModel >> childrenModels [

	^ self model models
]

{ #category : 'accessing' }
OPProjectViewModel >> findParentViewModel [

	^ nil
]

{ #category : 'accessing' }
OPProjectViewModel >> icon [

	^ OPCoreIcons openponkIcon
]

{ #category : 'accessing' }
OPProjectViewModel >> modelRootViewModel [

	^ self
]

{ #category : 'accessing' }
OPProjectViewModel >> project [

	^ self model
]

{ #category : 'accessing' }
OPProjectViewModel >> projectViewModel [
    ^ self
]

{ #category : 'announcement registration' }
OPProjectViewModel >> weakWhenChangedSend: aSelector to: aReceiver [

	^ self model weakWhenChangedSend: aSelector to: aReceiver
]
