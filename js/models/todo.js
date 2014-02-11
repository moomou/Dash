/*global Backbone */
var app = app || {};

(function () {
	'use strict';

	// Todo Model
	// ----------

	// Our basic **Todo** model has `title`, `order`, and `completed` attributes.
	app.Todo = Backbone.Model.extend({
		// Default attributes for the todo
		// and ensure that each todo created has `title` and `completed` keys.
		defaults: {
			title: '',
			completed: false,
            effort: ''
		},

		// Toggle the `completed` state of this todo item.
		toggle: function () {
            var time = this.get('title').split(' ')[0],
                pm = time.indexOf('pm') >= 0,
                time = time.substr(0, time.length - 2),
                time = time.split(':'),
                hour = parseInt(time[0]),
                min = parseInt(time[1]),
                effort = 0;

            var curHour = moment().hour(),
                curMin = moment().minute();

            if (pm && hour != 12) {
                hour += 12;
            }

            debugger;
            effort = curHour - hour + (curMin - min) / 60;

			this.save({
                effort: effort,
				completed: !this.get('completed')
			});
		}
	});
})();
