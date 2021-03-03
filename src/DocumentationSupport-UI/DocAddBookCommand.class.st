"
A command to add book to a library used in the toolbar.
"
Class {
	#name : #DocAddBookCommand,
	#superclass : #StCommand,
	#category : #'DocumentationSupport-UI-Commands'
}

{ #category : #default }
DocAddBookCommand class >> defaultDescription [

	^ 'Add a new book'
]

{ #category : #default }
DocAddBookCommand class >> defaultIconName [

	^ #add
]

{ #category : #default }
DocAddBookCommand class >> defaultName [

	^ 'Add book'
]

{ #category : #executing }
DocAddBookCommand >> execute [ 

	context addNewBook
]
