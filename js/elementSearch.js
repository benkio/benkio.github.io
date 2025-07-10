function elementSearch() {
    var filter = $("#elementSearch").val().toLowerCase();
    var testCondition = elem => filter === "" || $(elem).text().toLowerCase().includes(filter);
    $(".book").each((index, elem) => {
        if (testCondition(elem)) {
            $(elem).show();
        } else {
            $(elem).hide();
        }
    });
};
