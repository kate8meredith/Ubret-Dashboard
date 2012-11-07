UbretTool = require 'views/ubret_tool'

class ToolContainer extends Backbone.View
  tagName: 'div'
  className: 'tool-container'

  # toolTypes: 
  #   'table' : 'views/table'

  initialize: =>
    if @model?
      @createToolView()
      @model.on 'change', @updateTool()

  createToolView: =>
    if @model.has('type')
      @toolView = new UbretTool { model: @model, id: @model.get('channel') }

  updateTool: =>
    if @model.hasChanged('type')
      @toolView.remove()
      @createToolView()

   render: =>
     @$el.html @toolView?.render().el
     @

module.exports = ToolContainer