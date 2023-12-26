  function elementSearch(listId) {
      var filter = $("#elementSearch").val().toLowerCase();
      var testCondition = elem => filter === "" || $(elem).text().toLowerCase().includes(filter)
      $("#" + listId + " a").each((index, elem) => {
          var dropdownLinks = $(elem).parents().filter("div.dropdown");
          if (testCondition(elem)) {
              $(dropdownLinks).show();
              $(elem).show();
          } else {
              var childrenMatch = false
              var dropdownHide = $(dropdownLinks).children().find("a").each((index, celem) => {
                  childrenMatch = childrenMatch || testCondition(celem);
              });
              if (!childrenMatch) {
                  $(dropdownLinks).hide();
              }
              $(elem).hide();
          }
      });
  };
