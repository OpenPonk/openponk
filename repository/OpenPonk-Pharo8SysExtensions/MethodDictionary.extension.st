Extension { #name : #MethodDictionary }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
MethodDictionary >> at: key put: value [
	"Set the value at key to be value."

	| index |
	index := self findElementOrNil: key.
	(self basicAt: index)
		ifNil: [ tally := tally + 1.
			self basicAt: index put: key ].
	array at: index put: value.
	key flushCache.
	self fullCheck.
	(value respondsTo: #cachePragmas)
		ifTrue: [ value cachePragmas ].
	^ value
]
