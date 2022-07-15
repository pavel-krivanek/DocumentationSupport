Class {
	#name : #DocIncludeRessourceReference,
	#superclass : #MicPharoImageResourceReference,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #'instance creation' }
DocIncludeRessourceReference class >> handlesUriScheme: scheme [
	^ scheme = 'include'
]
