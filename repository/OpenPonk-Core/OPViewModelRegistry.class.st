"
Centralized registry managing ViewModels for a specific OPProject. 
Caches ViewModels by model instance and coordinates finding or instantiating the correct ViewModel for a given model or model type.
"
Class {
	#name : 'OPViewModelRegistry',
	#superclass : 'Object',
	#instVars : [
		'viewModelsCache',
		'project'
	],
	#classInstVars : [
		'ViewModelClassesCache'
	],
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'instance' }
OPViewModelRegistry class >> forNewProject [

	^ self forProject: OPProject new
]

{ #category : 'instance' }
OPViewModelRegistry class >> forProject: aProject [

	^ self basicNew
		  initializeForProject: aProject;
		  yourself
]

{ #category : 'accessing' }
OPViewModelRegistry class >> initializeViewModelClassesCache [

	ViewModelClassesCache := Dictionary new.
	OPViewModel allSubclassesDo: [ :each |
			each isAbstract ifFalse: [
				ViewModelClassesCache at: each modelClass put: each ] ].
	^ ViewModelClassesCache
]

{ #category : 'instance creation' }
OPViewModelRegistry class >> new [

	self error: 'ViewModelRegistry needs a project'
]

{ #category : 'initialization' }
OPViewModelRegistry class >> resetCache [

	<script>
	self initializeViewModelClassesCache
]

{ #category : 'accessing' }
OPViewModelRegistry class >> viewModelClassFor: aModelClass [

	^ (ViewModelClassesCache ifNil: [
		   self initializeViewModelClassesCache ]) at: aModelClass
]

{ #category : 'accessing' }
OPViewModelRegistry >> allChildrenFor: aModelObject [

	^ (self viewModelFor: aModelObject) allChildrenModels
]

{ #category : 'accessing' }
OPViewModelRegistry >> childrenFor: aModel [
    ^ (self viewModelFor: aModel) children
]

{ #category : 'accessing' }
OPViewModelRegistry >> createViewModelFor: aModelObject [

	^ (self createViewModelForType: aModelObject class)
		  model: aModelObject;
		  yourself
]

{ #category : 'accessing' }
OPViewModelRegistry >> createViewModelForType: aModelClass [

	^ (self class viewModelClassFor: aModelClass) new
		  registry: self;
		  yourself
]

{ #category : 'accessing' }
OPViewModelRegistry >> dependentFor: aModel [
    ^ (self viewModelFor: aModel) dependentElements
]

{ #category : 'accessing' }
OPViewModelRegistry >> dependsRoughlyTypeOf: firstObject on: secondObject [

	^ (self viewModelFor: firstObject) creationPriority
	  > (self viewModelFor: secondObject) creationPriority
]

{ #category : 'accessing' }
OPViewModelRegistry >> displayFor: aModel [
	^ (self viewModelFor: aModel) modelDisplayString
]

{ #category : 'accessing' }
OPViewModelRegistry >> iconFor: aModel [
    ^ (self viewModelFor: aModel) icon
]

{ #category : 'initialization' }
OPViewModelRegistry >> initialize [
    super initialize.
    viewModelsCache := WeakIdentityKeyDictionary new.
]

{ #category : 'accessing' }
OPViewModelRegistry >> initializeForProject: aProject [

	self initialize.
	project := aProject.
	self viewModelFor: aProject
]

{ #category : 'inspection' }
OPViewModelRegistry >> inspectTreeIn: specBuilder [

	<inspectorPresentationOrder: 10 title: 'Tree'>
	^ specBuilder newTree
		  roots:
			  (self projectViewModel
				   ifNil: [ #(  ) ]
				   ifNotNil: [ :pvm | { pvm } ]);
		  display: [ :aNode | aNode modelDisplayString ];
		  displayIcon: [ :aNode | aNode icon ];
		  children: [ :aNode | aNode children ];
		  expandRoots
]

{ #category : 'accessing' }
OPViewModelRegistry >> project [

	^ project
]

{ #category : 'accessing' }
OPViewModelRegistry >> projectViewModel [

	^ self viewModelFor: project
]

{ #category : 'accessing' }
OPViewModelRegistry >> registerNewViewModelOfClass: aViewModelClass createdBy: aModelCreationBlock [
	| viewModel model |
	viewModel := aViewModelClass new
		registry: self;
		yourself.
	model := aModelCreationBlock value: viewModel.
	^ viewModelsCache at: model put: viewModel
]

{ #category : 'accessing' }
OPViewModelRegistry >> removeViewModelFor: aModel [
	viewModelsCache removeKey: aModel ifAbsent: [ ]
]

{ #category : 'accessing' }
OPViewModelRegistry >> viewModelFor: aModelObject [

	^ viewModelsCache
		  at: aModelObject
		  ifAbsentPut: [ self createViewModelFor: aModelObject ]
]
