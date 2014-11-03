running
testAddElement
	"relation between element and metamodel is inverse is instance of element is created, element is automatically added to metamodel collection"
	Kind name: 'TestElement' metaModel: metaModel.
	
	self assert: ( metaModel modelElements anySatisfy: [ :each | each name = 'TestElement' ])