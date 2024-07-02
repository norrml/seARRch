###  HTML Search page

https://github.com/norrml/seARRch/blob/main/searrch.sh

Searches the word both sides. 
e.g. if 2 filenames are "one picnic america.jpg" and " picnic one america.jpg" , if the search is "one america" then both files show up, 
but when search it "one picnic" both show up.



## HTML Search 2 page.

https://github.com/norrml/seARRch/blob/main/notyetmade.sh 

Does not search the words in reverse, 
e.g. if 2 filenames are "one picnic america.jpg" and " picnic one america.jpg". 
when search  is "one america" then both files show up. 
but when search it "one picnic" only one file shows which is "one picnic america.jpg"


## Issue:

The file_list.json is accessible without website, Need to add this in nginx 
***
  location = /website/file_list.json {
        if ($http_referer !~* "^https://website.com/folder-if-any") {  return 444;    }
        alias /home/user/www/website/file_list.json;  
        } }
***

 "*"  (astericks) ? (question marks) and other regex do not work. 
