public - sticking
fix: aShape nearEndOfEdge: anEdge
	| callbacks block |
	callbacks := self callbacksOfEdge: anEdge.
	block := [ self doFix: aShape nearEndOfEdge: anEdge callbacks: callbacks ].
	aShape when: TRMouseDragEnd do: block.
	block value