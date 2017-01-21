app.Companies = function() {
  this._input = $('#companies-search-txt');
  this._initAutocomplete();
};

app.Companies.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/companies',
        appendTo: '#companies-search-results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
    },
    _render: function(ul, item) {
    var markup = [
      '<span class="name">' + item.name + '</span>',
      '<span class="website">' + item.website + '</span>'
    ];
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.name + ' - ' + ui.item.website);
    return false;
  }
};
