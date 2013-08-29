(function() {
  var Dashboard = this.Dashboard;

  Dashboard.DashboardView = Backbone.View.extend(_.extend({
    el: '#dashboard',

    initialize: function() {
      User.on('initialized', _.bind(function() {
        this.collection = User.current.dashboards;
      }, this));
      this.listenTo(Dashboard.State, 'change:currentDashboard', this.updateDashboard);
      this.model = Dashboard.State.get('currentDashboard');
      if (this.model) {
        this.sidebarTree = new Dashboard.SimpleTreeView({model: this.model}).render();
        this.render();
      }
    },

    treeLayout: d3.layout.tree(),

    render: function() {
      if (!this.model)
        return;
      var treeLayout = _.map(this.model.get('tools').toTree(), this.treeLayout);
    },

    updateDashboard: function(state, model) {
      this.$(".section-header h2").text(model.get('name'));
      this.model = model;
      this.sidebarTree == new Dashboard.SimpleTreeView({model: this.model}).render();
      this.render();
    }
  }, Dashboard.ToggleView));

  Dashboard.SimpleTreeView = Backbone.View.extend({
    el: '#tree-drawer',

    events: { 
      'click .toggle' : 'toggle'
    },

    initailize: function() {
      this.listenTo(this.model, 'add:tools remove:tools create:tools reset:tools', this.render);
    },

    toggle: function() {
      this.$el.toggleClass('active');
    },

    treeLayout: d3.layout.tree(),

    render: function() {
      var layout = _.map(this.model.get('tools').toTree(), this.treeLayout.nodes)

      var tree = d3.select(this.el).selectAll('ul.tree')
        .data(layout, function(d) { return d[0]._id; });

      tree.enter().append('ul')
        .attr('class', 'tree')

      tree.append('li')
          .attr('data-tool-id', function(d) { return d._id })
          .text(function(d) { return d.name; });

      var leaves = tree.selectAll('li')
        .data(function(d) { return d; }, function(d) { return d._id; })

      leaves.enter().append('li')
        .attr('data-tool-id', function(d) { return d._id })
        .style('padding-left', function(d) { return d.depth * 10 + "px"; })
        .text(function(d) { return d.name; });

      leaves.exit().remove();
      
      tree.exit().remove();
    }
  });

}).call(this);