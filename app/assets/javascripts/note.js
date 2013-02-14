$.rails.confirm = function(message, element) { 
  var state = element.data('state');
  var txt = element.text();
  if (!state) {
    element.data('state', 'last');
    element.text('Sure?');
    setTimeout(function() {
      element.data('state', null);
      element.text(txt);
    }, 2000);
    return false;
	} else {
    return true;
  }
};

$.rails.allowAction = function(element) {
	var message = element.data('confirm');
  var answer = false, callback;
	
	if (!message) { return true; }
	if ($.rails.fire(element, 'confirm')) {
    answer = $.rails.confirm(message, element);
    callback = $.rails.fire(element, 'confirm:complete', [answer]);
	}
	return answer && callback;
};

function send_message(event) {
  var $t = $(event.target)
  var btn_text = $t.text().toLowerCase();
  var content = $t.closest("li").children("span.content").text();
  switch (btn_text) {
    case "next week":
      var length = 10080; break;
    case "tomorrow":
      var length = 1440; break;
    case "in an hour": 
      var length = 60; break;
    case "30 minutes":
      var length = 30; break;
    case "right now":
      var length = 0; break;
    default:
      var length = 1;
  }
  console.log("Reminder: "+content+" sent in "+length+" minutes");

  $.ajax({
    url: "reminders/create.json",
    dataType: "json",
    data: {reminder: {content: content, 
      length: length, 
      timing: btn_text }},
    type: "GET"
  });

}





