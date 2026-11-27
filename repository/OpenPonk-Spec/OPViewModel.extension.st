Extension { #name : 'OPViewModel' }

{ #category : '*OpenPonk-Spec' }
OPViewModel >> shouldExpandInitiallyInTypesTree [

	^ false
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideChildrenIn: aTypesPresenter [

	^ #(  )
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideIconIn: aTypesPresenter [

	^ self icon
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideName [

	^ self modelDisplayString
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideSelectIn: aTypesPresenter [

	^ aTypesPresenter selectViewModel: self
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideSelectionStateIn: aTypesPresenter [

	^ aTypesPresenter selectionStateForViewModel: self
]

{ #category : '*OpenPonk-Spec' }
OPViewModel >> showHideUnselectIn: aTypesPresenter [

	^ aTypesPresenter unselectViewModel: self
]
