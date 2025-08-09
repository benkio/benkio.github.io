function elementSearch(type, withDropdown) {
    var filter = $("#elementSearch").val().toLowerCase();
    var testCondition = elem => filter === "" || $(elem).text().toLowerCase().indexOf(filter) >= 0;
    $("." + type).each((index, elem) => {
        var elemToChange = null;
        if ($(elem).is("a") && withDropdown) {
            elemToChange = $(elem).closest(".dropdown");
        } else elemToChange = elem;
        if (testCondition(elemToChange)) {
            $(elemToChange).show();
            $(elemToChange).children("button").show();
        } else {
            $(elemToChange).hide();
            $(elemToChange).children("button").hide();
        }
    });
};
