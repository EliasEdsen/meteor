import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.jade'



Meteor.startup () ->
  Meteor.call 'getServerTime', (err, res) ->
    if (err) then throw new Meteor.Error(err)
    Session.set('time', res + 1000)

    Meteor.setInterval () ->
      Session.set('time', Session.get('time') + 1000)
    , 1000

Template.auctions.helpers
  auction: -> Auctions.find()



# lot
Template.lot.helpers
  isActive: (expirationDate) -> moment(expirationDate, 'DD-MM-YYYY HH:mm').isAfter(Session.get('time'))
  itsMe   : (buyer)          -> Session.get('id') == buyer



# lotBody
Template.lotBody.events
  'click .Buy': (evt, instance) ->
    _id = val.value for val in evt.currentTarget.attributes when val.name == 'lotid'

    lot = Auctions.findOne({_id: _id})

    Auctions.update({_id: _id}, {
      $set: {buyer: Session.get('id')},
      $inc: {price: lot.step, step: 1}
    })

Template.lotBody.helpers
  getExpirationDateText: (expirationDate) -> moment(expirationDate, 'DD-MM-YYYY HH:mm').from(Session.get('time'))
  isActive             : (expirationDate) -> moment(expirationDate, 'DD-MM-YYYY HH:mm').isAfter(Session.get('time'))



# menu
Template.menu.onCreated menuOnCreated = () ->
  @id = prompt('Введите ID', 1) || 1
  Session.set('id', @id)

Template.menu.onRendered () ->
  @$('.datetimepicker').datetimepicker(format: 'DD-MM-YYYY HH:mm')

Template.menu.events
  'click .Add': (evt, instance) ->
    checkReplace = (obj) -> obj.value || obj.placeholder || null

    res = {}
    for val in evt.currentTarget.form
      res[val.name] = checkReplace val

    name           = res.name
    startPrice     = parseInt res.startPrice
    price          = startPrice
    step           = parseInt res.step
    expirationDate = res.expirationDate

    expirationDateBool = moment(expirationDate, 'DD-MM-YYYY HH:mm').isAfter(Session.get('time'))

    if startPrice && step && expirationDateBool
      Auctions.insert {name: name, startPrice: startPrice, price: price, step: step, expirationDate: expirationDate, author: instance.id, buyer: null}
    else
      return

Template.menu.helpers
  setData: -> moment().add(1, 'days').format('DD-MM-YYYY HH:mm')
