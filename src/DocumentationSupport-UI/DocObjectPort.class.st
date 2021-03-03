"
Simple support for a general object transfer in Spec. Calls `object:` to the transmission destination.
"
Class {
	#name : #DocObjectPort,
	#superclass : #SpInputPort,
	#category : #'DocumentationSupport-UI-Support'
}

{ #category : #'handling transmission' }
DocObjectPort >> incomingTransmission: anObject from: aTransmission [

	self destinationPresenter object: anObject
]
