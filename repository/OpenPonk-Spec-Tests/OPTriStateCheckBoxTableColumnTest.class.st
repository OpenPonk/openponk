"
Verifies tri-state checkbox table column icon resolution, click transitions, and Morphic cell construction.
"
Class {
	#name : 'OPTriStateCheckBoxTableColumnTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Widgets',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Widgets'
}

{ #category : 'tests' }
OPTriStateCheckBoxTableColumnTest >> testHandleClickTransitionsAndMissingCallbacks [

	| column activatedItems deactivatedItems |
	activatedItems := OrderedCollection new.
	deactivatedItems := OrderedCollection new.
	column := OPTriStateCheckBoxTableColumn new
		          onActivation: [ :item | activatedItems add: item ];
		          onDeactivation: [ :item | deactivatedItems add: item ];
		          yourself.

	self assert: column onActivation isNotNil description: 'onActivation getter must return configured block'.
	self assert: column onDeactivation isNotNil description: 'onDeactivation getter must return configured block'.

	column handleClickFor: #firstItem state: #unchecked.
	column handleClickFor: #secondItem state: #partial.
	column handleClickFor: #thirdItem state: #checked.

	self assert: activatedItems asArray equals: #( #firstItem #secondItem ).
	self assert: deactivatedItems asArray equals: #( #thirdItem ).
	self should: [ column handleClickFor: #badItem state: #invalid ] raise: Error.

	column
		onActivation: nil;
		onDeactivation: nil.
	column handleClickFor: #noOpItem state: #unchecked.
	column handleClickFor: #noOpItem state: #partial.
	column handleClickFor: #noOpItem state: #checked.
	self assert: activatedItems asArray equals: #( #firstItem #secondItem ).
	self assert: deactivatedItems asArray equals: #( #thirdItem )
]

{ #category : 'tests' }
OPTriStateCheckBoxTableColumnTest >> testIconNameForSupportedStatesAndErrorOnInvalidState [

	| column |
	column := OPTriStateCheckBoxTableColumn new.

	self assert: (column iconNameForState: #checked) equals: #checkedBox.
	self assert: (column iconNameForState: #partial) equals: #partialCheckedBox.
	self assert: (column iconNameForState: #unchecked) equals: #uncheckedBox.
	self should: [ column iconNameForState: #unknown ] raise: Error.
	self should: [ column iconNameForState: nil ] raise: Error
]

{ #category : 'tests' }
OPTriStateCheckBoxTableColumnTest >> testVisitorDispatchAndCellBuilderConstruction [

	| column visitor builder cell activatedItems buttonMorph |
	activatedItems := OrderedCollection new.
	column := (OPTriStateCheckBoxTableColumn evaluated: [ :item | item value ])
		          width: 20;
		          onActivation: [ :item | activatedItems add: item key ];
		          yourself.

	visitor := SpMorphicTableColumnVisitor new.
	visitor visit: column.

	cell := FTIndentedCellMorph new.
	builder := SpMorphicTreeTableCellBuilder new
		           cell: cell;
		           item: #groupA -> #partial;
		           yourself.
	builder visit: column.

	buttonMorph := cell allMorphs detect: [ :each | each isKindOf: ThreePhaseButtonMorph ].
	self assert: buttonMorph formSet equals: (Smalltalk ui icons iconFormSetNamed: #partialCheckedBox).
	self assert: buttonMorph target identicalTo: column.
	self assert: buttonMorph actionSelector equals: #handleClickFor:state:.

	buttonMorph doButtonAction: nil.
	self assert: activatedItems asArray equals: #( #groupA )
]
