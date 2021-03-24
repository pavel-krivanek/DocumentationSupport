"
A command to convert a library to its reStructuredText representation.
"
Class {
	#name : #DocConvertToReSTCommand,
	#superclass : #DocStCommand,
	#category : #'DocumentationSupport-reStructured'
}

{ #category : #default }
DocConvertToReSTCommand class >> defaultDescription [

	^ 'Convert library to reStructuredText'
]

{ #category : #accessing }
DocConvertToReSTCommand class >> defaultIconName [

	^ #glamorousSave
]

{ #category : #accessing }
DocConvertToReSTCommand class >> defaultName [

	^ 'Convert to reST'
]

{ #category : #accessing }
DocConvertToReSTCommand class >> priority [ 

	^ 120
]

{ #category : #executing }
DocConvertToReSTCommand >> execute [

	context convertToReStructuredText
]
