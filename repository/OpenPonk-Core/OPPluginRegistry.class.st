"
I am a container for all plugins.

!! Collaborators

DCPlugin
"
Class {
	#name : #OPPluginRegistry,
	#superclass : #Object,
	#instVars : [
		'plugins'
	],
	#classVars : [
		'Default'
	],
	#category : #'OpenPonk-Core-Plugin'
}

{ #category : #singleton }
OPPluginRegistry class >> default [
	^ Default ifNil: [ Default := self withAll ]
]

{ #category : #singleton }
OPPluginRegistry class >> resetDefault [
	<script>
	^ Default := nil
]

{ #category : #singleton }
OPPluginRegistry class >> setDefault: aDefault [
	<script>
	^ Default := aDefault
]

{ #category : #'instance creation' }
OPPluginRegistry class >> withAll [
	^ self new
		addAll;
		yourself
]

{ #category : #adding }
OPPluginRegistry >> add: aPlugin [
	plugins add: aPlugin
]

{ #category : #adding }
OPPluginRegistry >> addAll [
	plugins := OrderedCollection new.
	OPPlugin
		allSubclassesWithLevelDo: [ :each :level | 
			level > 0
				ifTrue: [ plugins add: each new ] ]
		startingLevel: 0
]

{ #category : #accessing }
OPPluginRegistry >> hasPluginFor: aModel [
	^ plugins anySatisfy: [ :each | each isPluginFor: aModel ]
]

{ #category : #initialization }
OPPluginRegistry >> initialize [
	super initialize.
	plugins := OrderedCollection new
]

{ #category : #accessing }
OPPluginRegistry >> pluginFor: aModel [
	^ plugins detect: [ :each | each isPluginFor: aModel ]
]

{ #category : #accessing }
OPPluginRegistry >> pluginForController: aController [
	^ plugins detect: [ :each | each isForController: aController ]
]

{ #category : #accessing }
OPPluginRegistry >> plugins [
	^ plugins
]

{ #category : #iterating }
OPPluginRegistry >> pluginsDo: aBlock [
	plugins do: aBlock
]
