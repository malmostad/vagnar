// Filter list of bookables for seller
jQuery(document).ready(function($) {
  var filter = {};
  var $filterForm = $("#filter-form");

  if ($filterForm.length) {
    var $items = $("#booking-schedule tbody tr");

    // Filter list on filter form change
    $filterForm.find("select").change(function() {
      readFilterForm();
      updateList();
    });
  }

  // Perform filtering based on data-x attributes
  function updateList() {
    // Build a somewhat complex selector to show/hide bookables
    var selector = "";
    if (!!filter.filter_place) selector += "[data-place='" + filter.filter_place + "']";
    if (!!filter.filter_date) selector += "[data-date='" + filter.filter_date + "']";
    if (!!filter.filter_time_slot) selector += "[data-time-slot='" + filter.filter_time_slot + "']";

    $items.filter(":hidden").show();

    // "All" selected for all select menues
    if (!selector) {
      $items.filter(":hidden").show();
    }
    else {
      $items.each(function() {
        $this = $(this);

        if ($this.is(selector) ) {
          $this.show();
        }
        else {
          $this.hide();
        }
      });
    }
  }

  function readFilterForm() {
    filter.filter_place = $("#filter_place option:selected").val();
    filter.filter_date = $("#filter_date option:selected").val();
    filter.filter_time_slot = $("#filter_time_slot option:selected").val();
  }
});
