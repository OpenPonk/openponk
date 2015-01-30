as yet unclassified
gtInspectorPresentation: composite
	<gtInspectorPresentationOrder: 30>
	composite table
		title: 'DC Model';
		display: [ self ];
		column: 'Property' evaluated: [ :each | 'Name' ];
		column: 'Value' evaluated: [ :each | each name ]