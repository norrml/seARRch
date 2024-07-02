#!/bin/bash
# TODO add instructions for user #
# someone make a sample env file so it can be used #
# Directory to store the HTML file # 
output_dir="/home/user/www/website/" ## TODO add the html root directory
json_file="/home/user/www/website/file_list.json" ## this is the full file list generated. 
temp_json_file="/home/user/www/website/temp_file_list.json"  ## temp for jq -s  code ## someone improve
index_html="$output_dir/index.html"
temp_index_html="$output_dir/temp_indexx.html"  # temp because idr.
update_time=$(date +%H":"%M","%a" "%d" "%b", "%Y)  ## latest updated time and date
#
echo "building page.. come back in one hour..." > "$index_html" ;  ## website goes down when the script runs
#
# Run the find command for the specified directory and store the output
(find /home/user/folder1/ /home/user/folder3/ -type f | sed "s|/home/user/folder1/|folder1: |" | sed "s|/home/user/folder3/|folder3: |" | sort | jq -R . | jq -s .) > "$json_file"; 
sleep 3; ## becouz system slow 
(rclone lsf cloudgdrive: --format "p" -R --files-only | sed 's|^|cloudgdrive: |' | sort | jq -R . | jq -s .) >> "$json_file";
sleep 3; ## becos 
(rclone lsf cloudsharepoint:  --format "p" -R --files-only  | sed 's|^|cloudsharepoint: |' | sort | jq -R . | jq -s .) >> "$json_file"  ; sleep 1;
(rclone lsf cloudbox: --format "p" -R --files-only  | sed 's|^|cloudbox: |'   | sort | jq -R . | jq -s .) >> "$json_file" ;
jq -s add $json_file > $temp_json_file && mv $temp_json_file $json_file ; sleep 5;  ## join the json files in one block
#
# Create the HTML file
#
cat <<EOF > "$temp_index_html"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>5tib 4tib sharep gdrive</title>
 <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto+Mono&display=swap">
<style>
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+Mono:wght@100..900&display=swap');
</style>
   <style>
        /* Styling for the body */
body {
    font-family: Roboto Mono ; ## Courier;
    background-color: #000; /* Black background */
    color: #fff; /* White text */
    margin: 10;
    padding: 0;
}
#searchInput {
    margin: 80px;
    padding: 10px;
    width: calc(80%); /* Full width minus margins */
    font-size: 16px;
    border: 0px #ccc;
    border-radius: 25px; /* Rounded corners */
    background-color: #333; /* Dark background for the search bar */
    color: #fff; /* White text for the search bar */
    outline: none;
  #  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    display: block;
    margin-left: auto;
    margin-right: auto;
}
#tree {
    font-size: 15px;
    margin: 5px;
    padding: 0;
    width: calc(100% - 50px); /* Full width minus margins */
    display: none; /* Initially hidden */
}
#tree ul {
    list-style-type: none;
    padding: 10;
}
#tree li {
    padding: 5px 0;
    border-bottom: 1px solid #535353 ; /* Light gray border between items */
}
#tree li:last-child {
    border-bottom: none; /* Remove the border for the last item */
}
    </style>
</head>
<body>
    <input type="text" id="searchInput" placeholder="...updated on $update_time ">
    <div id="tree">
        <!-- Tree structure will be dynamically added here -->
    </div>
      <!-- magic happens below  -->
    <script>
        var findData = [];
        // Function to generate tree structure and return an array of nodes
        function generateTree(parentElement, data) {
            var ul = document.createElement("ul");
            var nodes = [];
            data.forEach(function(item) {
                if (item) {
                    var li = document.createElement("li");
                    li.textContent = item;
                    ul.appendChild(li);
                    nodes.push({ name: item, element: li });
                }
            });
            parentElement.appendChild(ul);
            return nodes;
        }
        var treeContainer = document.getElementById("tree");
        var nodes = [];
        // Function to filter tree nodes based on search input
        function filterNodes(searchText) {
            var terms = searchText.toLowerCase().split(" ").filter(term => term);
            nodes.forEach(function(node) {
                var text = node.name.toLowerCase();
                var matches = terms.every(term => text.includes(term));
                node.element.style.display = matches ? "block" : "none";
            });
            // Show the tree container if search text is not empty
            treeContainer.style.display = searchText ? "block" : "none";
        }
        // Event listener for search input
        document.getElementById("searchInput").addEventListener("input", function() {
            var searchText = this.value.trim();
            filterNodes(searchText);
        });
        // Fetch the directory listing JSON file from the server
        fetch('file_list.json')
            .then(response => response.json())
            .then(data => {
                findData = data;
                nodes = generateTree(treeContainer, findData);
            })
            .catch(error => console.error('Error fetching the file list:', error));
    </script> 
      <!-- magic happens above  -->
</body>
</html>
EOF
mv "$temp_index_html" "$index_html";
exit 0;
