reading
readModelReferences: aRootFolder
	| dom |
	dom := XMLDOMParser parse: aRootFolder / 'models.xml'.
	^ dom root elements
		collect: [ :each | 
			(self modelIdFrom: (each attributeAt: #id))
				->
					(self
						readModelReference: (each attributeAt: #id)
						plugin: (each attributeAt: #plugin)
						pluginVersion: (each attributeAt: #pluginVersion)) ]