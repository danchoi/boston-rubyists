

var Update = Backbone.Model.extend({
  idAttribute: 'update_id',
  initialize: function() {
  }
});

var Updates = Backbone.Collection.extend({
  url: '/updates',
  model: Update,
  comparator: function(update) {
    return -update.get('date');
  }
});

