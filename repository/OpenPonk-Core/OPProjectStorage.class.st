"
Provides an in-image persistence registry for OPProjects. 
Used primarily for development, testing, and memory-backed project management without filesystem dependencies.
"
Class {
	#name : 'OPProjectStorage',
	#superclass : 'Object',
	#instVars : [
		'projects'
	],
	#classVars : [
		'Default'
	],
	#category : 'OpenPonk-Core-Models',
	#package : 'OpenPonk-Core',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPProjectStorage class >> default [
	<script: 'self default inspect'>
	^ Default ifNil: [ Default := self new ]
]

{ #category : 'class initialization' }
OPProjectStorage class >> reset [

	<script>
	Default := nil
]

{ #category : 'adding' }
OPProjectStorage >> add: aProject [
	self addFirst: aProject
]

{ #category : 'adding' }
OPProjectStorage >> addFirst: aProject [
	self ensureRemove: aProject.
	projects addFirst: aProject
]

{ #category : 'removing' }
OPProjectStorage >> ensureRemove: aProject [
	projects removeAllSuchThat: [ :each | each storageFile = aProject storageFile ]
]

{ #category : 'initialization' }
OPProjectStorage >> initialize [
	super initialize.
	projects := OrderedCollection new
]

{ #category : 'accessing' }
OPProjectStorage >> projects [
	^ projects
]

{ #category : 'removing' }
OPProjectStorage >> remove: aProject [
	self ensureRemove: aProject
]
