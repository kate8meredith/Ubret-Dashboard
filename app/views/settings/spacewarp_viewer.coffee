BaseView = require 'views/base_view'

class SpacewarpViewerSettings extends BaseView
  className: 'spacewarp-viewer-settings'
  template: require 'views/templates/settings/spacewarp_viewer'
  
  events:
    'click input[name="band"]'    : 'onBandChange'
    'change input[name="alpha"]'  : 'onAlphaChange'
    'change input[name="Q"]'      : 'onQChange'
    'change input.scale'          : 'onScaleChange'
    
    
  render: =>
    @$el.html @template()
    @ 
  
  onBandChange: (e) =>
    band = e.currentTarget.id
    
    color = @$el.find('.parameters.color')
    gray  = @$el.find('.parameters.grayscale')
    
    # Show and hide appropriate UI elements
    if band is 'gri'
      color.show()
      gray.hide()
    else
      color.hide()
      gray.show()
    
    @model.tool.setBand(band)
  
  onAlphaChange: (e) =>
    value = e.currentTarget.value
    @model.tool.updateAlpha(value)
    
  onQChange: (e) =>
    value = e.currentTarget.value
    @model.tool.updateQ(value)
  
  onScaleChange: (e) =>
    target = e.currentTarget
    band = target.name
    value = target.value
    @model.tool.updateScale(band, value)


module.exports = SpacewarpViewerSettings