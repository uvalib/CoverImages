$( document ).on('turbolinks:load', ()->

  tag = $('pre#response-json')
  tag.html JSON.stringify(tag.data('response-json'), null, 2)

)


