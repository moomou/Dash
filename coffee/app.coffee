API_Backend = null

# Update the current date
$('#datetime').html(moment().format("ddd, MMM Do YYYY"))

CURRENT_OFFSET = 0
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

visualize = (offset) ->
    weekOffset = moment().day(offset)

    $('#viz-week').html weekOffset.format "YYYY-ww"

    weekKey = weekOffset.format "YYYYww"
    weekData = []

    for num in [0..6]
        dayData = window.localStorage.getItem(weekKey+num)
        weekData[num] = JSON.parse dayData

    window.PlotPunchCard(null, weekData)

$('.js-save').click saveDayProgress

$('.js-viz-backward').click (e) ->
    CURRENT_OFFSET -= 7
    visualize(CURRENT_OFFSET)

$('.js-viz-forward').click (e) ->
    CURRENT_OFFSET += 7
    visualize(CURRENT_OFFSET)

new Draggabilly document.getElementById('todoapp')

visualize CURRENT_OFFSET
