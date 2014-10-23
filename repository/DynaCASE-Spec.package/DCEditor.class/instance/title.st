accessing
title
	| s |
	s := ''.
	project
		ifNotNil: [ 
			project dirty
				ifTrue: [ s := '* ' ].
			s := s , project projectName , ' - ' ].
	^ s , 'DynaCASE'