Class {
	#name : #OPIcons,
	#superclass : #Object,
	#classInstVars : [
		'Icons'
	],
	#category : #'OpenPonk-Core-Icons'
}

{ #category : #accessing }
OPIcons class >> at: aName ifAbsent: aBlock [

	Icons ifNil: [ Icons := Dictionary new ].

	^ Icons at: aName ifAbsentPut: [ 
		  [ MessageSend receiver: self selector: aName ]
			  on: MessageNotUnderstood
			  do: [ ^ aBlock value ] ]
]

{ #category : #'GT-InspectorExtensions' }
OPIcons class >> iconSelectors [

	^ self class selectorsInCategory: 'accessing - icons'
]

{ #category : #'GT-InspectorExtensions' }
OPIcons class >> inspectionIcons [

	<inspectorPresentationOrder: 40 title: 'Icons'>
	<script: 'self inspect'>
	| selectorsByForms |
	selectorsByForms := (self iconSelectors collect: [ :each | 
		                     ([ self perform: each ]
			                      on: Deprecation
			                      do: #resume) -> each ]) asDictionary.
	^ SpTablePresenter new
		  items:
			  (selectorsByForms keys sortedAs: [ :each | 
					   selectorsByForms at: each ]);
		  addColumn: (SpImageTableColumn new
				   title: 'Icon';
				   evaluated: [ :each | 
					   [ 
					   each scaledToSize:
							   (50 min: each width) @ (16 min: each height) ]
						   on: Deprecation
						   do: #resume ];
				   width: 50;
				   yourself);
		  addColumn: (SpStringTableColumn new
				   title: 'Name';
				   evaluated: [ :each | selectorsByForms at: each ];
				   yourself);
		  yourself
]

{ #category : #accessing }
OPIcons class >> resetIcons [
	<script>
	^ Icons := nil
]
