public - sticking
fix: aShape nearStartOfEdge: anEdge
	| callbacks block |
	callbacks := self callbacksOfEdge: anEdge.
	block := [ self doFix: aShape nearStartOfEdge: anEdge callbacks: callbacks ].
	aShape when: TRMouseDragEnd do: block.
	block value