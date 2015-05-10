Router.route '/', ->
  @layout 'layout'
  @render 'home'

Meteor.startup ->

  _.forEach crudastro.data, (collectionDefinition, collectionName) ->

    Router.route "/#{collectionName}", ->
      @layout 'layout'
      @render 'crudastroTable', data:
        collectionDefinition: _.defaults collectionDefinition, name: collectionName

    Router.route "/#{collectionName}/new", ->
      @layout 'layout'
      @render 'crudastroNew', data:
        collectionDefinition: _.defaults collectionDefinition, name: collectionName

    Router.route "/#{collectionName}/:documentId", ->
      @layout 'layout'
      @render 'crudastroEdit', data:
        documentId: @params.documentId
        collectionDefinition: _.defaults collectionDefinition, name: collectionName

Template.crudastroTable.onCreated ->

  @subscribe @data.collectionDefinition.name + "Table"

Template.crudastroTable.helpers

  documents: ->
    crudastro.collections[@collectionDefinition.name].find().fetch()

Template.crudastroTableCell.helpers

  value: ->
    console.log @
    @document[@column]

Template.crudastroTable.events

  'click .btn-remove': (event, template) ->
    params = Template.parentData(0)
    bootbox.confirm 'Are you sure want to delete this document?', (result) =>
      if result
        Meteor.call 'crudDelete', params.collectionName, @_id, (err) ->
          if err
            console.log err
          else
            console.log "ok"
    false

Template.crudastroNew.events

  'click .btn-save': (event, template) ->
    data = {}
    _.forEach @collectionDefinition.fields, (field) ->
      data[field.name] = template.$("form ##{field.name}").val()
    Meteor.call 'crudCreate', @collectionDefinition.name, data, (err) ->
      if err
        $.bootstrapGrowl("there was an error saving the document.", { type: 'error' });
        console.log err
      else
        $.bootstrapGrowl("the document has been successfully saved.", { type: 'success' });
    false

Template.crudastroEdit.onCreated ->
  @subscribe @data.collectionDefinition.name + "Document", @data.documentId

Template.crudastroEdit.helpers

  document: ->
    crudastro.collections[@collectionDefinition.name].findOne(@documentId)

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


Template.crudastroFormInput.helpers

  value: ->
    return unless @document
    @document[@field.name]


Template.layout.onRendered ->

  bootcards.init
    offCanvasHideOnMainClick: true
    offCanvasBackdrop: true
    enableTabletPortraitMode: true
    disableRubberBanding: true
    disableBreakoutSelector: 'a.no-break-out'

    if bootcards.isXS()
      window.addEventListener "orientationchange", ->
        window.scrollTo(0,0)
      , false
      window.scrollTo(0,0)
