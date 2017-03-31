Meteor.publish 'auctions', () ->
  Auctions.find()
