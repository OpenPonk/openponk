hooks
trachelShapeFor: anElement
	| c txt lines    |

	c := self colorFor: anElement.
	txt := self textFor: anElement.
	lines := txt lines.
	^ lines size <= 1
		ifTrue: [ self trachelShapeForOneLine: anElement ]
		ifFalse: [ self trachelShapeForMultiLine: anElement ]
