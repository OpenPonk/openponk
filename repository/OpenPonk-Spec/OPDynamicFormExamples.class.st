"
A bunch of examples demonstrating Form options.
"
Class {
	#name : 'OPDynamicFormExamples',
	#superclass : 'Object',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'examples' }
OPDynamicFormExamples >> exampleAllWidgets [

	<gtExample>
	| form window |
	form := OPDynamicForm new.
	(form addButton: 'Click Me') action: [ self inform: 'Yay!' ].
	(form addCheckbox: 'Check Mate')
		state: true;
		whenChangedDo: [ :newValue | 
			self inform: 'check mate: ' , newValue asString ].
	(form addCheckbox: 'Not Even Check')
		state: false;
		whenChangedDo: [ :newValue | 
			self inform: 'check: ' , newValue asString ].
	(form addDroplist: 'With Icons')
		items: #( announcement catalog class );
		display: [ :each | each asString ];
		displayIcon: [ :each :item | self iconNamed: each ];
		selectItem: #catalog;
		whenSelectedDo: [ :newValue | 
			self inform: 'icon: ' , newValue asString ].
	(form addEditableDroplist: 'Editable')
		items: #( abstract collection comments );
		display: [ :each | each asString ];
		selectItem: #collection;
		whenSelectedDo: [ :newValue | 
			self inform: 'editable icon: ' , newValue asString ].
	form addSeparator.
	form addLabel: 'There''s a separator above me and below me'.
	form addSeparator.
	(form addText: 'Enter Some Text') text: 'poem required'.
	(form addTextInput: 'Single Line With Ghost Text') placeholder: 'wooo!'.
	(form addTextInput: 'Line Without Ghosts') text: 'no ghosts allowed'.
	window := form openWithSpec.
	window extent: 400 @ 600.
	form rebuildWidget.
	^ self
]
