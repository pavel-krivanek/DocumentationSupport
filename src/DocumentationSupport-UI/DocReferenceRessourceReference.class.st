Class {
	#name : #DocReferenceRessourceReference,
	#superclass : #MicPharoImageResourceReference,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #'instance creation' }
DocReferenceRessourceReference class >> handlesUriScheme: scheme [
	^ scheme = 'ref'
]
