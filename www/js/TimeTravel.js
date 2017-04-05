var dilationChart;
var chartData = {
    labels: [],
    datasets: [
        {
            label: "Dilation",
            fillColor: "rgba(151,187,205,0.2)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            pointHighlightFill: "#fff",
            pointHighlightStroke: "rgba(151,187,205,1)",
            data: [],
        }
    ]
};

var TimeTravel = function ()
{
};

TimeTravel.prototype = {
   init:function()
    {
        if (localStorage["dilations"] != undefined)
        {
           var dilations = JSON.parse(localStorage["dilations"]);
           for(var i; i < dilations.length; i++)
           {
               var d = dilations[i];
               chartData["labels"].add("" + d['time'].hour + ":" + d['time'].minutes);
               chartData["data"].add(d['factor'] -1);
           }
        }
    },
    onGPSSuccess: function(position)
    {
        Processing.getInstanceById('dilationInterface').setGPSOK();
        Processing.getInstanceById('dilationInterface').unsetGPSError();
        var s = new Speed(position.coords.speed, 'm/s');
        Processing.getInstanceById('dilationInterface').speedUpdate(s.kmh);
        timeTravel.storeDilation(s);
    },
    onGPSError: function(error)
    {
        Processing.getInstanceById('dilationInterface').setGPSError();
    },
    storeDilation: function (speed)
    {
        var timestamp = new Date();
        var obj = {'speed': speed,
             'factor': td.timeDilationFactor(speed),
             'time': timestamp
            };
        var jsonObj = JSON.stringify(obj);
        if (localStorage["dilations"] === undefined)
        {
            localStorage["dilations"] = JSON.stringify([]);
        }
        var dilations = JSON.parse(localStorage["dilations"]);
        dilations[dilations.length] = obj;
        localStorage["dilations"] = JSON.stringify(dilations);
        
        if (localStorage["max"] === undefined)
        {
            localStorage["max"] = jsonObj;
        }
        else
        {
            if (JSON.parse(localStorage["max"])["speed"].ms < speed.ms)
            {
                localStorage["max"] = jsonObj;
            }
        }
        timeTravel.updateTotals(obj);
    },
    updateTotals: function (obj)
    {
        if (localStorage["totalDilation"] === undefined)
        {
            localStorage["totalDilation"] = JSON.stringify(0);
        }
        
        var dilations = JSON.parse(localStorage["dilations"]).sort(function(x, y){
            return x['time'] - y['time'];
        });
        var old_total = JSON.parse(localStorage["totalDilation"]);
        var currentDil = obj.factor - 1;
        var currentTime = moment(obj.time);
        var lastTime = dilations[dilations.length - 1]['time'];
        var currentDur = currentTime.diff(lastTime, 'seconds');
        var new_total = currentDil * currentDur + old_total;
        localStorage["totalDilation"] = JSON.stringify(new_total);
        var maxSpeed = JSON.parse(localStorage["max"])['speed'].kmh;
        var maxDilation = JSON.parse(localStorage["max"])['factor'] - 1;
        
        $('#maxSpeed').text(maxSpeed.toFixed(2) + " Km/h");
        $('#maxDilation').text(maxDilation + " s");
        $('#accumulatedDilation').text(new_total + " s")
    },
    logMap: function(value, start1, stop1, start2, stop2)
    {
        var percent = 100 * ((value - start1) / (stop1 - start1));
        var ranged = (Math.log(percent)+Math.E)*13.6547627816;
        return start2 + (stop2 - start2) * (ranged / 100);
    }
};

timeTravel = new TimeTravel();

// Options: throw an error if no update is received every 30 seconds.
//
var watchID = navigator.geolocation.watchPosition(timeTravel.onGPSSuccess, timeTravel.onGPSError, {maximumAge: 3000, timeout: 5000, enableHighAccuracy: true});

$(document).on('swipeleft', '.ui-page', function(event){    
    if(event.handled !== true) // This will prevent event triggering more then once
    {    
        var nextpage = $.mobile.activePage.next('[data-role="page"]');
        // swipe using id of next page if exists
        if (nextpage.length > 0) {
            $.mobile.changePage(nextpage, {transition: "slide", reverse: false}, true, true);
        }
        event.handled = true;
    }
    return false;         
});

$(document).on('swiperight', '.ui-page', function(event){     
    if(event.handled !== true) // This will prevent event triggering more then once
    {      
        var prevpage = $(this).prev('[data-role="page"]');
        if (prevpage.length > 0) {
            $.mobile.changePage(prevpage, {transition: "slide", reverse: true}, true, true);
        }
        event.handled = true;
    }
    return false;            
});

$(function(){
    timeTravel.init();
    console.log("Running chart: ");
    var ctx = $("#dilationChart").get(0).getContext("2d");
    dilationChart = new Chart(ctx).Line(chartData);
    console.log(dilationChart);
    $.mobile.changePage(nextpage, {transition: "slide", reverse: false}, true, true);
    });