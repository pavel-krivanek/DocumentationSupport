"
A command to convert a library to its reStructuredText representation.
"
Class {
	#name : #DocConvertToReSTCommand,
	#superclass : #StCommand,
	#category : #'DocumentationSupport-UI-Commands'
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

{ #category : #executing }
DocConvertToReSTCommand >> execute [

	context convertToReStructuredText
]
