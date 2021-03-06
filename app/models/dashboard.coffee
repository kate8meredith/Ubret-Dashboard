Manager = require 'modules/manager'

class Dashboard extends Backbone.AssociatedModel
  sync: require 'lib/ouroboros_sync'
  urlRoot: '/dashboards'
  user: require 'lib/user'

  relations: [
    type: Backbone.Many
    key: 'tools'
    relatedModel: require 'models/tool'
    collectionType: require 'collections/tools'
  ]

  defaults:
    tools: []
    name: "My Great Dashboard"
    project: "default"

  initialize: ->
    if Manager.get 'project' then @set 'project', Manager.get 'project'
    @once 'sync', => Manager.set 'dashboardId', @id
    @on 'add:tools', (tool) => tool.save()
    @on 'layout', (layout) => @get('tools').arrangeWindows layout
    super

  createTool: (type) =>
    @get('tools').add
      tool_type: type

  fork: =>
    url = Manager.api() 
    url = "#{url}/dashboards/#{@id}/fork"
    $.ajax url,
      type: 'POST'
      crossDomain: true
      dataType: 'json'
      beforeSend: (xhr) =>
        xhr.setRequestHeader 'Authorization', @user.current.basicAuth()

module.exports = Dashboard