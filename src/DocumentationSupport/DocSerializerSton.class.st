"
I perform serialization of document libraries.
"
Class {
	#name : #DocSerializerSton,
	#superclass : #Object,
	#instVars : [
		'currentPath'
	],
	#category : #'DocumentationSupport-Serialization'
}

{ #category : #accessing }
DocSerializerSton >> currentPath [ 

	^ currentPath
]

{ #category : #accessing }
DocSerializerSton >> currentPath: anObject [

	currentPath := anObject
]

{ #category : #exporting }
DocSerializerSton >> export: aLibrary to: direcotoryFileReference [

	self currentPath: direcotoryFileReference asFileReference.
	self visitLibrary: aLibrary.

]

{ #category : #visiting }
DocSerializerSton >> visitBook: aBook [

	| ref | 
		
	ref := self currentPath / aBook key.
	ref ensureCreateDirectory.
	(ref / 'description', 'ston') writeStreamDo: [ :aStream |
		STON put: aBook onStreamPretty: aStream  ].
	aBook chapters do: [ :aChapter |
		currentPath := ref.
		aChapter acceptVisitor: self ].

]

{ #category : #visiting }
DocSerializerSton >> visitChapter: aChapter [

	| ref | 
	
	ref := self currentPath / aChapter key, 'ston'.
	
	ref writeStreamDo: [ :aStream | 
		STON put: aChapter onStreamPretty: aStream ]

]

{ #category : #visiting }
DocSerializerSton >> visitLibrary: aLibrary [ 

	| ref | 
	
	ref := self currentPath / aLibrary name.
	ref ensureDeleteAll.
	ref ensureCreateDirectory.
	aLibrary books do: [ :aBook |
		currentPath := ref.
		aBook acceptVisitor: self ].
	


]
