document.addEventListener("DOMContentLoaded", function(event) {
  function uuidv4() {
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    );
  }

  $(document).on('click', '#more-options', function() {
    $('.more-options').show();
    $('#more-options').attr('id', 'hide-more-options').html('Hide options')
    return false;
  });

  $(document).on('click', '#hide-more-options', function() {
    $('.more-options').hide();
    $('#hide-more-options').attr('id', 'more-options').html('More options');
    return false;
  });

  if (document.cookie.match(/^(.*;)?\s*track_uuid\s*=\s*[^;]+(.*)?$/) == null) {
    expiry = new Date();
    expiry.setTime(expiry.getTime() + (10 * 60 * 10000)); // Ten minutes
    document.cookie = "track_uuid=" + uuidv4() + "; expires=" + expiry.toGMTString();
  }
});
