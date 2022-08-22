Class {
	#name : #DocReference,
	#superclass : #MicAbsoluteResourceReference,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #'instance creation' }
DocReference class >> handlesUriScheme: scheme [
	^ scheme = 'ref'
]
