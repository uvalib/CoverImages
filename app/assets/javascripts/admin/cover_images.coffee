$( document ).on('turbolinks:load', ()->

  $('[data-toggle="tooltip"]').tooltip()
  $('[type="checkbox"]').bootstrapSwitch();

  tag = $('pre#response-json')
  tag.html JSON.stringify(tag.data('response-json'), null, 2)

)


