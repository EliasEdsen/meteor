Meteor.startup () ->
  console.log 'Server has been start'

  Meteor.methods
    getServerTime: () -> Date.now()
