instance creation
newModel
	| aModel |
	aModel := self modelClass new.
	(aModel respondsTo: #name:)
		ifTrue: [ aModel name: self modelClass name ].
	^ aModel