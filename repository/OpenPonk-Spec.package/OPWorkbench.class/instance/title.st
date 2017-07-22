protocol
title
	| s |
	s := ''.
	project
		ifNotNil: [ project dirty
				ifTrue: [ s := '* ' ].
			s := s , project name , ' - ' ].
	^ s , 'OpenPonk'