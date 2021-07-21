Extension { #name : #OPProject }

{ #category : #'*OpenPonk-Spec' }
OPProject >> open [
	^ OPWorkbench openProject: self
]

{ #category : #'*OpenPonk-Spec' }
OPProject class >> openOnModel: aModel [
	^ self new
		name: aModel name;
		addModel: aModel;
		open
]
