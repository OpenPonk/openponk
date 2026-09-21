"
Mock ViewModel exposing Magritte descriptions to test OPDynamicForm bindings.
"
Class {
	#name : 'OPFormTestViewModel',
	#superclass : 'OPViewModel',
	#category : 'OpenPonk-Core-UndoRedo-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo-Tests'
}

{ #category : 'as yet unclassified' }
OPFormTestViewModel class >> modelClass [

	^ OPFormTestModel
]

{ #category : 'as yet unclassified' }
OPFormTestViewModel >> basicRemoveModel [ ^ self
]

{ #category : 'as yet unclassified' }
OPFormTestViewModel >> descriptionCategory [
	<magritteDescription>
	^ MASingleOptionDescription new
		accessor: (self descriptionAccessor: #category);
		label: 'Category';
		options: #(alpha beta gamma);
		priority: 3;
		yourself
]

{ #category : 'as yet unclassified' }
OPFormTestViewModel >> descriptionIsActive [
	<magritteDescription>
	^ MABooleanDescription new
		accessor: (self descriptionAccessor: #isActive);
		label: 'Is Active';
		priority: 2;
		yourself
]

{ #category : 'as yet unclassified' }
OPFormTestViewModel >> findParentViewModel [ ^ nil
]
