Class {
	#name : 'OPNoModelAdapter',
	#superclass : 'Object',
	#classInstVars : [
		'instance'
	],
	#category : 'OpenPonk-Core-Adapters',
	#package : 'OpenPonk-Core',
	#tag : 'Adapters'
}

{ #category : 'accessing' }
OPNoModelAdapter class >> instance [

	^ instance ifNil: [ instance := self basicNew ]
]

{ #category : 'instance creation' }
OPNoModelAdapter class >> new [

	^ self instance
]

{ #category : 'initialization' }
OPNoModelAdapter class >> reset [

	<script>
	instance := nil
]
