"
Mock ViewModel overriding descriptionName with a pluggable Magritte accessor to test dynamic form undo/redo.
"
Class {
	#name : 'OPFormPluggableTestViewModel',
	#superclass : 'OPViewModel',
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'accessing' }
OPFormPluggableTestViewModel class >> modelClass [
	^ OPFormTestModel
]

{ #category : 'private' }
OPFormPluggableTestViewModel >> basicRemoveModel [
	^ self
]

{ #category : 'magritte-descriptions' }
OPFormPluggableTestViewModel >> descriptionName [
	<magritteDescription>
	| accessor |
	accessor := MAPluggableAccessor
		read: [ :me | me model name ]
		write: [ :me :newValue |
			me model name: newValue.
			self modelChanged ].
	^ MAMemoDescription new
		accessor: accessor;
		label: 'Name';
		priority: 1;
		yourself
]

{ #category : 'accessing' }
OPFormPluggableTestViewModel >> findParentViewModel [
	^ nil
]
