<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Documentation Dropdown</title>
<style>
  /* Style for the dropdown */
  .dropdown {
    position: relative;
    display: inline-block;
  }

  /* Dropdown button */
  .dropdown-button {
    background-color: #4CAF50;
    color: white;
    padding: 16px;
    font-size: 16px;
    border: none;
    cursor: pointer;
  }

  /* Dropdown content (hidden by default) */
  .dropdown-content {
    display: none;
    position: absolute;
    background-color: #f9f9f9;
    min-width: 400px;
    z-index: 1;
    box-shadow: 0 8px 16px 0 rgba(0,0,0,0.2);
    padding: 12px;
    overflow-y: scroll;
    max-height: 70vh;
  }

  /* Links inside the dropdown */
  .dropdown-content a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
  }

  /* Change color of dropdown links on hover */
  .dropdown-content a:hover {
    background-color: #f1f1f1;
  }

  /* Show the dropdown menu on hover */
  .dropdown:hover .dropdown-content {
    display: block;
  }

  /* Change the background color of the dropdown button when the dropdown content is shown */
  .dropdown:hover .dropdown-button {
    background-color: #3e8e41;
  }
</style>
</head>
<body>

<!-- Dropdown menu -->
<div class="dropdown">
  <button class="dropdown-button">Select Documentation</button>
  <div class="dropdown-content">
    <a href="#wrangler-class-documentation">Wrangler Class Documentation</a>
    <a href="#graphs-class-documentation">Graphs Class Documentation</a>
  </div>
</div>

<!-- Markdown content -->
<div id="wrangler-class-documentation">
  <!-- Insert Wrangler class documentation markdown here -->
</div>

<div id="graphs-class-documentation">
  <!-- Insert Graphs class documentation markdown here -->
</div>

</body>
</html>

