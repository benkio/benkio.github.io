  function elementSearch(listId) {
      var filter = $("#elementSearch").val().toLowerCase();
      $("#"+ listId +" a").each((index, elem) => {
          if (filter === "" || $(elem).text().toLowerCase().includes(filter)) {
              $(elem).show();
          } else {
              $(elem).hide();
          }
      });
  };
