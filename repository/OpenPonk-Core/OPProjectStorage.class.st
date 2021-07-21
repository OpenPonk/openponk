"
I provide in-image persistance for DCProjects.
"
Class {
	#name : #OPProjectStorage,
	#superclass : #Object,
	#instVars : [
		'projects'
	],
	#classVars : [
		'Default'
	],
	#category : #'OpenPonk-Core-Models'
}

{ #category : #accessing }
OPProjectStorage class >> default [
	<script: 'self default inspect'>
	^ Default ifNil: [ Default := self new ]
]

{ #category : #accessing }
OPProjectStorage class >> reset [
	"self reset"
	<script: 'self reset'>

	Default := nil
]

{ #category : #adding }
OPProjectStorage >> add: aProject [
	self addFirst: aProject
]

{ #category : #adding }
OPProjectStorage >> addFirst: aProject [
	self ensureRemove: aProject.
	projects addFirst: aProject
]

{ #category : #removing }
OPProjectStorage >> ensureRemove: aProject [
	projects removeAllSuchThat: [ :each | each storageFile = aProject storageFile ]
]

{ #category : #initialization }
OPProjectStorage >> initialize [
	super initialize.
	projects := OrderedCollection new
]

{ #category : #accessing }
OPProjectStorage >> projects [
	^ projects
]

{ #category : #removing }
OPProjectStorage >> remove: aProject [
	self ensureRemove: aProject
]
