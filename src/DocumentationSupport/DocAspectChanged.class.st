"
An announcemnet about change of a general aspect of a model
"
Class {
	#name : #DocAspectChanged,
	#superclass : #Announcement,
	#instVars : [
		'aspect',
		'origin'
	],
	#category : #'DocumentationSupport-Support'
}

{ #category : #accessing }
DocAspectChanged >> aspect [

	^ aspect
]

{ #category : #accessing }
DocAspectChanged >> aspect: anObject [

	aspect := anObject
]

{ #category : #accessing }
DocAspectChanged >> origin [

	^ origin
]

{ #category : #accessing }
DocAspectChanged >> origin: anObject [

	origin := anObject
]
