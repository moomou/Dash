/*global Backbone */
var app = app || {};

(function () {
	'use strict';

	// Todo Collection
	// ---------------

	// The collection of todos is backed by *localStorage* instead of a remote
	// server.
	var Todos = Backbone.Collection.extend({
		// Reference to this collection's model.
		model: app.Todo,

		// Save all of the todo items under the `"todos"` namespace.
		localStorage: new Backbone.LocalStorage('todos-backbone'),

		// Filter down the list of all todo items that are finished.
		completed: function () {
			return this.filter(function (todo) {
				return todo.get('completed');
			});
		},

		// Filter down the list to only todo items that are still not finished.
		remaining: function () {
			return this.without.apply(this, this.completed());
		},

		nextOrder: function (title) {
            var offset = null;

			if (!this.length) {
				return 1;
			}

            if (title.indexOf("!") == 0) {
                offset = 0;
            } else if (title.indexOf("?") == 0) {
                offset = 100;
            } else {
                offset = 1000;
            }

			return _.uniqueId() + offset;
		},

		comparator: function (todo) {
			return parseInt(todo.get('order'));
		}
	});

	// Create our global collection of **Todos**.
	app.todos = new Todos();
})();
