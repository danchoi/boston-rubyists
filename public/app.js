
$(function() {
  _.templateSettings = { interpolate : /\{\{(.+?)\}\}/g };
  window.Update = Backbone.Model.extend({ idAttribute: 'update_id' });
  window.UpdatesList = Backbone.Collection.extend({
    url: function(){ 
      return ('/updates?from_time=' + this.models[this.models.length-1].get("date"));
    },
    model: Update,
    comparator: function(x) { return x.get('date'); }
  });
  window.Updates = new UpdatesList();
  window.UpdateView = Backbone.View.extend({
    tagName: "div",
    classNme: "update",
    template: _.template( $('#update-template').html() ),
    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    }
  });

  window.BlogPost = Backbone.Model.extend({ idAttribute: 'href' });
  window.BlogPostsList = Backbone.Collection.extend({
    url: function() {
      return ('/blog_posts?from_time=' + this.models[this.models.length-1].get("date"));
    },
    model: BlogPost,
    comparator: function(x) { return x.get('date'); }
  });
  window.BlogPosts = new BlogPostsList();
  window.BlogPostView = Backbone.View.extend({
    tagName: "div",
    classNme: "blogpost",
    template: _.template( $('#blogpost-template').html() ),
    render: function() {
      $(this.el).html(this.template(this.model.toJSON()));
      return this;
    }
  });


  window.AppView = Backbone.View.extend({
    initialize: function() {
      Updates.bind('add', this.addOneUpdate, this);
      Updates.bind('reset', this.addAllUpdates, this);
      Updates.bind('refresh', this.addAllUpdates, this);

      BlogPosts.bind('add', this.addOneBlogPost, this);
      BlogPosts.bind('reset', this.addAllBlogPosts, this);
      Updates.bind('refresh', this.addAllBlogPosts, this);
    },
    addOneUpdate: function(x) {
      var updateView = new UpdateView({model: x});
      $("#updates").prepend(updateView.render().el);
    },
    addAllUpdates: function() { Updates.each(this.addOneUpdate); },

    addOneBlogPost: function(x) {
      var blogpostView = new BlogPostView({model: x});
      $("#blogposts").prepend(blogpostView.render().el);
    },
    addAllBlogPosts: function() { BlogPosts.each(this.addOneBlogPost); },
  });

  window.App = new AppView;

});
