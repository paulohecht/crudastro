Router.route '/', ->
  @layout 'layout'
  @render 'home'

Meteor.startup ->

  _.forEach crudastro.data, (collectionDefinition, collectionName) ->

    Router.route "/#{collectionName}", ->
      Session.set "loading", true
      subscription = Meteor.subscribe collectionName + "Table"
      Tracker.autorun => Session.set "loading", false if subscription.ready()
      @layout 'layout'
      @render 'table', data:
        collectionName: collectionName
        collectionDefinition: collectionDefinition

    Router.route "/#{collectionName}/new", ->
      @layout 'layout'
      @render 'new', data:
        collectionName: collectionName
        collectionDefinition: collectionDefinition

    Router.route "/#{collectionName}/:documentId", ->
      Session.set "loading", true
      subscription = Meteor.subscribe collectionName + "Document", @params.documentId
      Tracker.autorun => Session.set "loading", false if subscription.ready()
      @layout 'layout'
      @render 'edit', data:
        documentId: @params.documentId
        collectionName: collectionName
        collectionDefinition: collectionDefinition

Template.table.helpers

  isLoading: ->
    Session.get "loading"

  documents: ->
    crudastro.collections[@collectionName].find().fetch()

  fieldValue: ->
    document = Template.parentData(1)
    document[@]

Template.form.helpers

  isLoading: ->
    Session.get "loading"

  document: ->
    return {} unless @documentId
    crudastro.collections[@collectionName].findOne(@documentId)


Template.form.events

  'submit form': (event, template) ->
    data = {}
    _.forEach @collectionDefinition.fields, (field) ->
      data[field.name] = template.$("form ##{field.name}").val()
    Meteor.call 'crudCreate', @collectionName, data, (err) ->
      if err
        console.log err
      else
        console.log "ok"
    false