Extension { #name : #CompiledMethod }

{ #category : #'*OpenPonk-Pharo8SysExtensions' }
CompiledMethod >> cachePragmas [

	self pragmas do: [ :pragma | pragma class addToCache: pragma ]
]
