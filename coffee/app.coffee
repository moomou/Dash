API_Backend = null

WEEK_NUM = moment().format 'YYYYww'
CURRENT_OFFSET = 0

###
# A simple function to calculate network latency
###
getLatency = () ->
    server =
        imgUrl: "http://google.com"

    img = document.createElement('IMG')
    server.startTime = (new Date()).getTime()

    img.onload = () ->
        server.endTime = (new Date()).getTime()
        console.log server.endTime - server.startTime
        $('.network').html(server.endTime - server.startTime)

    img.src = server.imgUrl

###
# Retrieve all objects in the data store
# and store that as a json blob suitable
# for visualization with d3
###
saveDayProgress = () ->
    output = {}

    for k, v of window.localStorage
        continue if k == 'todos-backbone'
        entry = JSON.parse v
        continue if not entry.completed

        [time, tag, other] = entry.title.split ' '
        continue if not tag

        if not output[tag]
            console.log "creating #{tag}"
            output[tag] = entry.effort or 1
        else
            output[tag] += entry.effort or 1

    filename = moment().format('YYYYwwd')
    console.log "Uploading #{filename}"

    window.localStorage.setItem filename, JSON.stringify output

###
# Update checkboxes
###
checkboxUpdate = (weekKey) ->
    localforage.getItem(weekKey).then (value) ->
        if not value
            $('.ck').prop('checked', false)
        cks = $('.ck')
        for ck, ind in cks
            if value[ind]
                ck.checked = true
            else
                ck.checked = false

###
# Generate the visualization
###
visualize = (offset) ->
    weekOffset = moment().day(offset)
    weekKey    = weekOffset.format "YYYYww"
    weekData   = []

    $('#viz-week').html weekOffset.format "YYYY-ww"

    for num in [0..6]
        dayData = window.localStorage.getItem(weekKey+num)
        weekData[num] = JSON.parse dayData

    # Update viz
    debugger
    checkboxUpdate weekKey
    window.PlotPunchCard null, weekData

# Event Handler
$('.js-save').click saveDayProgress

$('.js-viz-backward').click (e) ->
    CURRENT_OFFSET -= 7
    visualize(CURRENT_OFFSET)

$('.js-viz-forward').click (e) ->
    CURRENT_OFFSET += 7
    visualize(CURRENT_OFFSET)

$('.ck').change (e) ->
    index = $(e.target).parent().index()
    localforage.getItem(WEEK_NUM).then (value) ->
        if not value
            checked = {}
            checked[index] = $(e.target).prop('checked')
            localforage.setItem(WEEK_NUM, checked)
        else
            value[index] = $(e.target).prop('checked')
            localforage.setItem(WEEK_NUM, value)

# Kick off the page
new Draggabilly document.getElementById('todoapp')

visualize CURRENT_OFFSET

# Update the current date
$('#datetime').html(moment().format("ddd, MMM Do YYYY"))
