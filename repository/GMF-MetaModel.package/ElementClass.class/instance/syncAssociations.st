synchronization
syncAssociations
	self relationships
		do: [ :asoc | 
			| source target |
			source := asoc start.
			target := asoc end.
			source owner ifNotNil: [ source associations: (source associations reject: [ :each | each == asoc ]) ].
			target owner ifNotNil: [ target associations: (target associations reject: [ :each | each == asoc ]) ] ]