# File Manipulation
GOAL_URL = "https://dl.dropboxusercontent.com/u/46323284/personal_goal.csv"
PROGRESS_URL = "https://dl.dropboxusercontent.com/u/46323284/personal_data.csv"

GetCSVLines = (csv) ->
    lines = csv.split('\n')
    fields = _(lines[0].split(',')).map (item) -> item.toLowerCase()
    lines = lines[1..]
    [fields, lines]

GOAL = []
PROGRESS = []

###
$.when(
    $.get(GOAL_URL, (file) ->
        [fields, lines] = GetCSVLines(file)
        _(lines).each (line) ->
            vals = line.split ','
            obj = _.object _.zip(fields, vals)
            GOAL.push obj
    ),
    $.get(PROGRESS_URL, (file) ->
        [fields, lines] = GetCSVLines(file)
        _(lines).each (line) ->
            vals = line.split ','
            obj = _.object _.zip(fields, vals)
            obj.data = _(vals[1..]).map (val) -> val.length
            PROGRESS.push obj
    )
).then(
    () -> # on success
        console.log "loading OK"
        window.PlotPunchCard GOAL, PROGRESS
    () ->  # on error
)
###
