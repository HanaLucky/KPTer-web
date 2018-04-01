const positionTop = $("header > nav").height();
const sections = $(".section-container > h2");
for (var i = 0; i < sections.length; i++) {
  var $section = $(sections[i]);
  var y = $section.offset().top;
  var id = $section.attr("id");
  var title = $section.text();
  $("#kpter-heading").append('<li><a href="#' + id + '" class="active">' + title + '</a></li>');
}
$('.container').on('click', 'a[href^="#"]', function() {
  var headerHeight = $("header > nav").height();
  var speed = 400;
  var href= $(this).attr("href");
  var target = $(href == "#" || href == "" ? 'html' : href);
  var position = target.offset().top - headerHeight - 15;
  $('body,html').animate({scrollTop: position}, speed, 'swing');
  return false;
});
