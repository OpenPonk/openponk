I am a base class for DCNavigator adapters.

!! Collaborators

DCNavigator

!! Usage

Subclass me and implement mapping methods returning a dictionary.

The retrieval makes usage of object's model hierarchy (up to DCModelObject), so it is possible to add behavior directly to parent class, such as 
[ [ [
displayBlock
    ^ { DCModelObject -> [  :o | self myCustomNameFor: o ] }
] ] ]
Because this will affect all objects, it is recommended to also reimplement ==hasMappingFor:== method to specify whether the adapter is applicable for this particular object.