"
A command to export library back to its repository.
"
Class {
	#name : #DocExportCommand,
	#superclass : #StCommand,
	#category : #'DocumentationSupport-UI-Commands'
}

{ #category : #default }
DocExportCommand class >> defaultDescription [

	^ 'Export library to disk'
]

{ #category : #default }
DocExportCommand class >> defaultIconName [

	^ #glamorousSave
]

{ #category : #default }
DocExportCommand class >> defaultName [

	^ 'Export'
]

{ #category : #executing }
DocExportCommand >> execute [ 

	context export
]
