import { Meteor } from 'meteor/meteor';

Meteor.startup () ->
  console.log 'Server has been start'

  Meteor.methods
    getServerTime: () -> Date.now()
