#first load data and clean it
height = 400
width = 550
margin = 6

yTitles = "日, 一,二,三,四,五,六".split ","
xTitles = [
    "learning"
    "algorithm"
    "startup"
    "reading"
    "hack"
]

plotPunchCard = (weekData) ->
    $('#svg-container').empty()
    xScale = d3.scale.linear()
        .domain([0, 6])

    # Fix this scale
    yScale = d3.scale.linear()
        .domain([0, 3])

    canvas = d3.select('#svg-container')
        .append('svg')
        .attr("width", width - 2 * margin)
        .attr("height", height - 2 * margin)

    spaceX = (width - margin*10) / xTitles.length

    # X Axis
    canvas.append("g").
        selectAll(".rule").
        data([0..xTitles.length]).
        enter().
        append("text").
        attr("x", (d) -> d * (spaceX + margin) + 8*margin).
        attr("y", height - margin * 2.5).
        attr("text-anchor", "middle").
        attr('fill', 'black').
        text (d) -> xTitles[d]

    # Y Axis
    canvas.append("g").
        selectAll(".rule").
        data([0..yTitles.length]).
        enter().
        append("text").
        attr("y", (d) -> 5*margin + 25*margin * yScale(d)).
        attr("x", margin).
        attr("text-anchor", "left").
        attr("font-family", "serif").
        attr('fill', 'black').
        text (d) -> yTitles[d]

    # Plotting data
    for day, y in weekData
        continue if not day

        for task, pt of day
            console.log task
            x = xTitles.indexOf task

            canvas.append('g')
                .attr("transform", "translate(#{2.5*margin}, 0)")
                .selectAll('circle')
                .data([pt])
                .enter()
                .append('circle')
                .style("fill", randomColor({hue: 'monochrome', count: 1})[0])
                .attr('r', (d) -> Math.abs(d)*6)
                .attr('transform', () ->
                    "translate(#{x * (spaceX + margin) + 5*margin}, #{5*margin + 25 * margin * yScale(y)})")
                .on('mouseover', () ->
                    circle = d3.select this
                    circle.attr('r', (d) -> Math.abs(d) * 15)
                    circle.append('title').text((d) -> d + ' hour')
                )
                .on('mouseout', () ->
                    circle = d3.select this
                    circle.attr('r', (d) -> Math.abs(d) * 6)
                    circle.select('title').remove()
                )

window.PlotPunchCard = (goalData, progressData) ->
    console.log progressData
    plotPunchCard progressData
