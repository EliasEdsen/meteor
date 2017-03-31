Router.configure
  layoutTemplate: 'layout'

Router.route '/', () ->
  @render 'page1'

Router.route '/(.*)', () ->
  @render 'page1'
