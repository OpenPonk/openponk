accessing
pluginForController: aController
	^ plugins detect: [ :each | each diagramControllerClass = aController class ]