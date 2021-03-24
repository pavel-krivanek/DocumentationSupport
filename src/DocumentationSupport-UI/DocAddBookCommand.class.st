"
A command to add book to a library used in the toolbar.
"
Class {
	#name : #DocAddBookCommand,
	#superclass : #DocStCommand,
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

{ #category : #accessing }
DocAddBookCommand class >> priority [ 

	^ 300
]

{ #category : #executing }
DocAddBookCommand >> execute [ 

	context addNewBook
]
