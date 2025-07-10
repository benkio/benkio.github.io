function elementSearch(type) {
    var filter = $("#elementSearch").val().toLowerCase();
    var testCondition = elem => filter === "" || $(elem).text().toLowerCase().includes(filter);
    $("." + type).each((index, elem) => {
        if (testCondition(elem)) {
            $(elem).show();
        } else {
            $(elem).hide();
        }
    });
};
