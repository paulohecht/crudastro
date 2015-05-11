Router.route '/', ->
  @layout 'layout'
  @render 'home'

Router.route "/:collectionName", ->
  @state.set 'collectionName', @params.collectionName
  @state.set 'query', @params.query
  @layout 'layout'
  @render 'crudastroTable', data:
    collectionDefinition: _.defaults crudastro.data[@params.collectionName], name: @params.collectionName
    query: @params.query

Router.route "/:collectionName}/new", ->
  @layout 'layout'
  @render 'crudastroNew', data:
    collectionDefinition: _.defaults _.clone(crudastro.data[@params.collectionName]), name: @params.collectionName

Router.route "/:collectionName/:documentId", ->
  @layout 'layout'
  @render 'crudastroEdit', data:
    documentId: @params.documentId
    collectionDefinition: _.defaults _.clone(crudastro.data[@params.collectionName]), name: @params.collectionName

Template.crudastroTable.onCreated ->
  @autorun =>
    collectionName = Iron.controller().state.get('collectionName')
    query = Iron.controller().state.get('query')
    @subscribe "crudastroTable", collectionName, query

Template.crudastroTable.helpers

  documents: ->
    sort = {}
    sort[@query.sort] = if @query.dir == 'desc' then -1 else 1 if @query.sort
    crudastro.pages[@collectionDefinition.name].find({}, {sort: sort}).fetch()

  isEmpty: ->
    crudastro.counts[@collectionDefinition.name].findOne().count == 0

Template.crudastroTableCell.helpers

  value: ->
    @document[@column]

Template.crudastroTableColumnHeader.helpers

  url: (options) ->
    query = _.clone @query
    if @column == @query.sort && !@query.dir
      query.dir = 'desc'
    else
      delete query.dir
    query.sort = @column
    "/#{@collectionDefinition.name}?#{$.param(query)}"

  isCurrentSort: ->
    @column == @query.sort

  isDesc: ->
    @query.dir == 'desc'

Template.crudastroTablePagination.helpers

  count: ->
    crudastro.counts[@collectionDefinition.name].findOne().count

  pages: ->
    count = crudastro.counts[@collectionDefinition.name].findOne().count
    totalPagesShown = crudastro.maxPagesShownInPaginator
    totalPages = crudastro.totalPages(count)
    half = Math.floor(totalPagesShown/2)
    if totalPages <= totalPagesShown
      return [0..totalPages-1]
    page = Number(@query.page) || 0
    if page <= half
      return [0..(totalPagesShown-1)]
    if page >= totalPages - half
      return [(totalPages-totalPagesShown)..(totalPages-1)]
    [(page-half)..(page+half)]

  hasPreviousElipisis: ->
    count = crudastro.counts[@collectionDefinition.name].findOne().count
    totalPages = crudastro.totalPages(count)
    half = Math.floor(crudastro.maxPagesShownInPaginator/2)
    page = Number(@query.page) || 0
    (totalPages > crudastro.maxPagesShownInPaginator) && (page > half)

  isCurrentPageFirst: ->
    page = Number(@query.page) || 0
    page == 0

  firstUrl: ->
    query = _.defaults page: 0, @query
    "/#{@collectionDefinition.name}?#{$.param(query)}"

  hasNextElipisis: ->
    count = crudastro.counts[@collectionDefinition.name].findOne().count
    totalPages = crudastro.totalPages(count)
    half = Math.floor(crudastro.maxPagesShownInPaginator/2)
    page = Number(@query.page) || 0
    (totalPages > crudastro.maxPagesShownInPaginator) && (page < totalPages - half)

  lastUrl: ->
    count = crudastro.counts[@collectionDefinition.name].findOne().count
    totalPages = crudastro.totalPages(count)
    query = _.defaults page: totalPages-1, @query
    "/#{@collectionDefinition.name}?#{$.param(query)}"

  isCurrentPageLast: ->
    page = Number(@query.page) || 0
    count = crudastro.counts[@collectionDefinition.name].findOne().count
    totalPages = crudastro.totalPages(count)
    page == totalPages - 1

Template.crudastroTablePaginationPageButton.helpers

  isCurrentPage: ->
    page = Number(@query.page) || 0
    parseInt(page) == parseInt(@page)

  pageCaption: ->
    @page+1

  url: (options) ->
    query = _.clone @query
    query.page = @page
    "/#{@collectionDefinition.name}?#{$.param(query)}"

Template.crudastroTable.events

  'click .btn-remove': (event, template) ->
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
  @subscribe "crudastroDocument", @data.collectionDefinition.name, @data.documentId

Template.crudastroEdit.helpers

  document: ->
    crudastro.collections[@collectionDefinition.name].findOne(@documentId)

Template.crudastroEdit.events

  'click .btn-save': (event, template) ->
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
