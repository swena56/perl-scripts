<!DOCTYPE html>
<html>

<head>
  <meta charset="utf-8">
  <title>Dynamic Table</title>
  <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>

      <!-- Jquery 2.1 -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js"></script>

        <!-- Latest compiled and minified CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

        <!-- Optional theme -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">

        <!-- Latest compiled and minified JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>
        

  <style>

    body {
      font: 24px monospace
    }

    table {
      margin: 10px;
      font-size: 24px;
    }

    td {
      padding: 5px;
      border-bottom: 1px solid black;
    }

    td.update { 
      color: blue;
    }

    td.enter {
      color: green;
    }

    td.exit, tr.exit td {
      color: red;
    }

    td.row-header {
      border-right: 1px solid black;
      font-weight: bold;
    }

  </style>
</head>

<body>

<table class='table table-hover table-responsive'>
</table>

</body>

<script>


  ///////////////////////////////////////////
  // UTILITY FUNCTIONS

  // Make a key-value object
  var make_key_value = function(k, v) {
    return { key: k,
             value: v
           };
  };

  // Join a key array with a data array.
  // Return an array of key-value objects.
  var merge = function(keys, values) {
    var l = keys.length;
    var d = [], v, k;
    for(var i = 0; i < l; i++) {
      v = values[i].slice();
      k = keys[i];
      d.push( make_key_value( k, v ));
    }
    return d;
  };

  
  // Shuffles the input array.
  function shuffle(array) {
    var m = array.length, t, i;
    while (m) {
      i = Math.floor(Math.random() * m--);
      t = array[m], array[m] = array[i], array[i] = t;
    }
    return array;
  }

  // Returns a random integer between min and max
  // Using Math.round() will give you a non-uniform distribution!
  function get_random_int(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  // Resize the array, append random numbers if new_size is larger than array.
  function update_array(a, new_size) {

    a = a || [];

    if (a.length > new_size) {
      return a.slice(0, new_size);
    }

    var delta = new_size - a.length;
    for(var i = 0; i < delta; i++) {
      a.push(get_random_int(0, 9));
    }

    return a;
  };


  ////////////////////////////////////////////////////////////
  // GENERATE DATA
  var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");

  var letter_to_data = {}; // store row data

  var generate_data = function() {
    var i, j, a, l;
    var letters = shuffle(alphabet);
    var num_cols = get_random_int(3, 10);
    var num_rows = get_random_int(5, 15); 

    var row_data = []
    for (i = 0; i < num_rows; i++ ) {
      l = letters[i];
      a = update_array( letter_to_data[l], num_cols );
      letter_to_data[l] = a; // store data
      row_data.push( a );
    }

    for (i = num_rows; i < letters.length; i++) {
      delete letter_to_data[i];
    }

    letters = letters.slice(0, num_rows);

    return merge(letters, row_data);
  };

  /////////////////////////////////////////////
  // DEFINE HELPER FUNCTIONS
  // Extract key from key-value object.
  var get_key = function(d) { return d && d.key; };

  // Extract data from a key-value object.
  // Prepend the key so it is the first item in the values array.
  var extract_row_data = function(d) {

    var values = d.value.slice();

    // Prepend the key
    values.unshift(d.key); 
    return values;

  };

  // Use data as is.
  var ident = function(d) { return d; };


  /////////////////////////////////////////////
  // UPDATE THE TABLE

  // Select the table element
  var table = d3.select('table');

  // Define function to update data
  var update = function(new_data) {

    var rows = table.selectAll('tr').data(new_data, get_key);

    //////////////////////////////////////////
    // ROW UPDATE SELECTION

    // Update cells in existing rows.
    var cells = rows.selectAll('td').data(extract_row_data);

    cells.attr('class', 'update');

    // Cells enter selection
    cells.enter().append('td')
      .style('opacity', 0.0)
      .attr('class', 'enter')
      .transition()
      .delay(900)
      .duration(500)
      .style('opacity', 1.0);

    cells.text(ident);

    // Cells exit selection
    cells.exit()
      .attr('class', 'exit')
      .transition()
      .delay(200)
      .duration(500)
      .style('opacity', 0.0)
      .remove();

    //////////////////////////////////////////
    // ROW ENTER SELECTION
    // Add new rows
    var cells_in_new_rows = rows.enter().append('tr')
                                .selectAll('td')
                                .data(extract_row_data);

    cells_in_new_rows.enter().append('td')
      .style('opacity', 0.0)
      .attr('class', 'enter')
      .transition()
      .delay(900)
      .duration(500)
      .style('opacity', 1.0);

    cells_in_new_rows.text(ident);

    /////////////////////////////////////////
    // ROW EXIT SELECTION
    // Remove old rows
    rows.exit()
      .attr('class', 'exit')
      .transition()
      .delay(200)
      .duration(500)
      .style('opacity', 0.0)
      .remove();

    table.selectAll('tr').select('td').classed('row-header', true);

  };

  // Generate and display some random table data.
  update(generate_data());

  setInterval(function() {
    update(generate_data());
  }, 3500);


</script>


</html>
