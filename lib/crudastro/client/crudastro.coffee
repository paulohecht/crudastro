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
      @render 'crudastroTable', data:
        collectionName: collectionName
        collectionDefinition: collectionDefinition

    Router.route "/#{collectionName}/new", ->
      @layout 'layout'
      @render 'crudastroNew', data:
        collectionName: collectionName
        collectionDefinition: collectionDefinition

    Router.route "/#{collectionName}/:documentId", ->
      Session.set "loading", true
      subscription = Meteor.subscribe collectionName + "Document", @params.documentId
      Tracker.autorun => Session.set "loading", false if subscription.ready()
      @layout 'layout'
      @render 'crudastroEdit', data:
        documentId: @params.documentId
        collectionName: collectionName
        collectionDefinition: collectionDefinition

Template.crudastroTable.helpers

  isLoading: ->
    Session.get "loading"

  documents: ->
    crudastro.collections[@collectionName].find().fetch()

  fieldValue: ->
    document = Template.parentData(1)
    document[@]

Template.crudastroForm.helpers

  isLoading: ->
    Session.get "loading"

  document: ->
    return {} unless @documentId
    crudastro.collections[@collectionName].findOne(@documentId)

  fieldValue: ->
    params = Template.parentData(1)
    document = crudastro.collections[params.collectionName].findOne(params.documentId)
    document[@name] if document



Template.crudastroNew.events

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

Template.crudastroEdit.events

  'submit form': (event, template) ->
    params = Template.parentData(0)
    id = params.documentId
    data = {}
    _.forEach @collectionDefinition.fields, (field) ->
      data[field.name] = template.$("form ##{field.name}").val()
    Meteor.call 'crudUpdate', @collectionName, id, data, (err) ->
      if err
        console.log err
      else
        console.log "ok"
    false