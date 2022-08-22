Class {
	#name : #DocIncludeReference,
	#superclass : #MicAbsoluteResourceReference,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #'instance creation' }
DocIncludeReference class >> handlesUriScheme: scheme [
	^ scheme = 'include'
]
