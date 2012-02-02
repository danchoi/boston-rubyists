
$(function() {

  window.Update = Backbone.Model.extend({
    idAttribute: 'update_id',
    initialize: function() {
    }
  });

  window.UpdatesList = Backbone.Collection.extend({
    url: '/updates',
    model: Update,
    comparator: function(update) {
      return -update.get('date');
    }
  });

  window.Updates = new UpdatesList();


  _.templateSettings = {
    interpolate : /\{\{(.+?)\}\}/g
  };

  window.UpdateView = Backbone.View.extend({
    tagName: "div",
    classNme: "update",
    template: _.template( $('#update-template').html() ),
    initialize: function() {
    },
    render: function() {
      // http://documentcloud.github.com/underscore/#template
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    }
    
  });

  window.AppView = Backbone.View.extend({
    initialize: function() {
      Updates.bind('add', this.addOne, this);
      Updates.bind('reset', this.addAll, this);
      Updates.bind('all', this.render, this);
      Updates.fetch();
    },
    render: function() { },
    addOne: function(update) {
      var view = new UpdateView({model: update});
      $("#updates").prepend(view.render().el);
    },
    addAll: function() {
      Updates.each(this.addOne);
    },
    
  });

  window.App = new AppView;

});
