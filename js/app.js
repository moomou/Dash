
// Generated by IcedCoffeeScript 1.6.3-e
(function() {
  var height, margin, plotPunchCard, width, xTitles, yTitles;



  height = 400;

  width = 550;

  margin = 6;

  yTitles = "日, 一,二,三,四,五,六".split(",");

  xTitles = ["learning", "algorithm", "ai", "startup", "reading", "thinking", "hack"];

  plotPunchCard = function(weekData) {
    var canvas, day, pt, spaceX, task, x, xScale, y, yScale, _i, _j, _k, _len, _ref, _ref1, _results, _results1, _results2;
    $('#svg-container').empty();
    xScale = d3.scale.linear().domain([0, 6]);
    yScale = d3.scale.linear().domain([0, 3]);
    canvas = d3.select('#svg-container').append('svg').attr("width", width - 2 * margin).attr("height", height - 2 * margin);
    spaceX = (width - margin * 10) / xTitles.length;
    canvas.append("g").selectAll(".rule").data((function() {
      _results = [];
      for (var _i = 0, _ref = xTitles.length; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
      return _results;
    }).apply(this)).enter().append("text").attr("x", function(d) {
      return d * (spaceX + margin) + 8 * margin;
    }).attr("y", height - margin * 2.5).attr("text-anchor", "middle").attr('fill', 'black').text(function(d) {
      return xTitles[d];
    });
    canvas.append("g").selectAll(".rule").data((function() {
      _results1 = [];
      for (var _j = 0, _ref1 = yTitles.length; 0 <= _ref1 ? _j <= _ref1 : _j >= _ref1; 0 <= _ref1 ? _j++ : _j--){ _results1.push(_j); }
      return _results1;
    }).apply(this)).enter().append("text").attr("y", function(d) {
      return 5 * margin + 25 * margin * yScale(d);
    }).attr("x", margin).attr("text-anchor", "left").attr("font-family", "serif").attr('fill', 'black').text(function(d) {
      return yTitles[d];
    });
    _results2 = [];
    for (y = _k = 0, _len = weekData.length; _k < _len; y = ++_k) {
      day = weekData[y];
      if (!day) {
        continue;
      }
      _results2.push((function() {
        var _results3;
        _results3 = [];
        for (task in day) {
          pt = day[task];
          console.log(task);
          x = xTitles.indexOf(task);
          _results3.push(canvas.append('g').attr("transform", "translate(" + (2.5 * margin) + ", 0)").selectAll('circle').data([pt]).enter().append('circle').style("fill", '#' + Math.floor(Math.random() * 16777215).toString(16)).attr('r', function(d) {
            return Math.abs(d) * 6;
          }).attr('transform', function() {
            return "translate(                    " + (x * (spaceX + margin) + 5 * margin) + ",                    " + (5 * margin + 25 * margin * yScale(y)) + ")";
          }));
        }
        return _results3;
      })());
    }
    return _results2;
  };

  window.PlotPunchCard = function(goalData, progressData) {
    console.log(progressData);
    return plotPunchCard(progressData);
  };

}).call(this);

// Generated by IcedCoffeeScript 1.6.3-e
(function() {
  var API_Backend, CURRENT_OFFSET, WEEK_NUM, checkboxUpdate, getLatency, saveDayProgress, visualize;



  API_Backend = null;

  WEEK_NUM = moment().format('YYYYww');

  CURRENT_OFFSET = 0;


  /*
  # A simple function to calculate network latency
  */

  getLatency = function() {
    var img, server;
    server = {
      imgUrl: "http://google.com"
    };
    img = document.createElement('IMG');
    server.startTime = (new Date()).getTime();
    img.onload = function() {
      server.endTime = (new Date()).getTime();
      console.log(server.endTime - server.startTime);
      return $('.network').html(server.endTime - server.startTime);
    };
    return img.src = server.imgUrl;
  };


  /*
  # Retrieve all objects in the data store
  # and store that as a json blob suitable
  # for visualization with d3
  */

  saveDayProgress = function() {
    var entry, filename, k, other, output, tag, time, v, _ref, _ref1;
    output = {};
    _ref = window.localStorage;
    for (k in _ref) {
      v = _ref[k];
      if (k === 'todos-backbone') {
        continue;
      }
      entry = JSON.parse(v);
      if (!entry.completed) {
        continue;
      }
      _ref1 = entry.title.split(' '), time = _ref1[0], tag = _ref1[1], other = _ref1[2];
      if (!tag) {
        continue;
      }
      if (!output[tag]) {
        console.log("creating " + tag);
        output[tag] = entry.effort || 1;
      } else {
        output[tag] += entry.effort || 1;
      }
    }
    filename = moment().format('YYYYwwd');
    console.log("Uploading " + filename);
    return window.localStorage.setItem(filename, JSON.stringify(output));
  };


  /*
  # Update checkboxes
  */

  checkboxUpdate = function(weekKey) {
    return localforage.getItem(weekKey).then(function(value) {
      var ck, cks, ind, _i, _len, _results;
      if (!value) {
        $('.ck').prop('checked', false);
      }
      cks = $('.ck');
      _results = [];
      for (ind = _i = 0, _len = cks.length; _i < _len; ind = ++_i) {
        ck = cks[ind];
        if (value[ind]) {
          _results.push(ck.checked = true);
        } else {
          _results.push(ck.checked = false);
        }
      }
      return _results;
    });
  };


  /*
  # Generate the visualization
  */

  visualize = function(offset) {
    var dayData, num, weekData, weekKey, weekOffset, _i;
    weekOffset = moment().day(offset);
    weekKey = weekOffset.format("YYYYww");
    weekData = [];
    $('#viz-week').html(weekOffset.format("YYYY-ww"));
    for (num = _i = 0; _i <= 6; num = ++_i) {
      dayData = window.localStorage.getItem(weekKey + num);
      weekData[num] = JSON.parse(dayData);
    }
    debugger;
    checkboxUpdate(weekKey);
    return window.PlotPunchCard(null, weekData);
  };

  $('.js-save').click(saveDayProgress);

  $('.js-viz-backward').click(function(e) {
    CURRENT_OFFSET -= 7;
    return visualize(CURRENT_OFFSET);
  });

  $('.js-viz-forward').click(function(e) {
    CURRENT_OFFSET += 7;
    return visualize(CURRENT_OFFSET);
  });

  $('.ck').change(function(e) {
    var index;
    index = $(e.target).parent().index();
    return localforage.getItem(WEEK_NUM).then(function(value) {
      var checked;
      if (!value) {
        checked = {};
        checked[index] = $(e.target).prop('checked');
        return localforage.setItem(WEEK_NUM, checked);
      } else {
        value[index] = $(e.target).prop('checked');
        return localforage.setItem(WEEK_NUM, value);
      }
    });
  });

  new Draggabilly(document.getElementById('todoapp'));

  visualize(CURRENT_OFFSET);

  $('#datetime').html(moment().format("ddd, MMM Do YYYY"));

}).call(this);
