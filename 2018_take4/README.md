you can use curl to get the puzzle input into a file  

you first need to login to AoC in browser and inspect source  
You are looking for session cookie  
Copy it into a file with format
```
session=<cookie_value>
```

than you can use curl command:  
`curl -b <path_to_cookie>file> <url_of_input> > <file_to_write>.txt`  
or something similar

more info here: https://www.reddit.com/r/adventofcode/comments/1887vk8/2023_day_0bash_how_do_i_fetch_the_input_data_via/
